//
//  EMVReader.m
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import "EMVReader.h"
#import "CAPDU.h"
#import "RAPDU.h"
#import "CAPDUGenerator.h"
#import "RAPDUParser.h"
#import "HexUtil.h"
#import "NSData+ByteManipulation.h"
#import "EmvAIDList.h"
#import "CardAID.h"
#import "EMVCardModel.h"

@interface EMVReader() <DeviceReaderDelegate>

@property (strong, nonatomic) RAPDUParser *rapduParser;

@end

@implementation EMVReader

@synthesize deviceReader;
@synthesize delegate;

NSString *const ReadingPublicDataErrorDomain = @"ReadingPublicDataErrorDomain";

#pragma mark - Initialization

-(instancetype)initWithDeviceReader:(id<DeviceReader>)deviceReader
                        andDelegate:(id <PDReaderDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        
        self.delegate = delegate;
        self.deviceReader = deviceReader;
        self.deviceReader.delegate = self;
        self.rapduParser = [RAPDUParser new];
    }
    
    return self;
}

#pragma mark - Interface Method

-(void)readPublicData
{
    //will callback one of DeviceReaderDelegate prepare card methods
    [self.deviceReader prepareCard];
}

#pragma mark - DeviceReaderDelegate

-(void)didPrepareCardSuccessfully
{
    [self tryToReadPublicDataWithThreeMethods];
}

-(void)didFailPrepareCardWithError:(NSError *)error
{
    [self.delegate didFailToReadPublicDataWithError:error];
}

- (void)didFailFinalizeCardWithError:(NSError *)error
{
    
}

- (void)didFinalizeCardSuccessfully
{
    
}

#pragma mark - Read AFL Records Methods

-(void)tryToReadPublicDataWithThreeMethods
{
    EMVCardModel *card;
    //card and reader connected
    NSError *pseError = nil;
    //try via pse
    NSArray *aflRecordsPSE = [self readPublicDataViaPSEWithError:&pseError];
    if (!aflRecordsPSE) {
        [self.delegate didFailToReadPublicDataWithError:pseError];
        return;
    }else{
        card = [[EMVCardModel alloc] initWithAFLRecords:aflRecordsPSE];
        [self.delegate didReadPublicData:card];
        return;
    }
    
    NSError *aidError = nil;
    //try via AID
    NSArray *aflRecordsAID = [self readPublicDataViaAIDsError:&aidError];
    if (!aflRecordsAID) {
        [self.delegate didFailToReadPublicDataWithError:aidError];
        return;
    }else{
        card = [[EMVCardModel alloc] initWithAFLRecords:aflRecordsPSE];
        [self.delegate didReadPublicData:card];
        return;
    }
    
    NSError *ppseError = nil;
    //try via ppse
    NSArray *aflRecordsPPSE = [self readPublicDataViaPPSEWithError:&ppseError];
    if (!aflRecordsPPSE) {
        [self.delegate didFailToReadPublicDataWithError:ppseError];
    }else{
        card = [[EMVCardModel alloc] initWithAFLRecords:aflRecordsPPSE];
        [self.delegate didReadPublicData:card];
        return;
    }
}

//TODO fix no SFI from parsing
-(NSArray *)readPublicDataViaPPSEWithError:(NSError **)error
{
    RAPDU *ppseResponse = [self selectPPSEDirError:error];
    NSArray *aid = [self.rapduParser aidFromRAPDU:ppseResponse error:error];
    if (!aid) {
        NSNumber* sfi = [self.rapduParser sfiFromRAPDU:ppseResponse error:error];
        aid = [self getAidFromSFI:sfi error:error];
    }
    
    NSArray *publicData = [self readPublicDataForAID:aid error:error];
    return publicData;
}

-(NSArray *)readPublicDataViaPSEWithError:(NSError **)error
{
    RAPDU *pseResponse = [self selectPSEDirError:error];
    NSNumber* sfi = [self.rapduParser sfiFromRAPDU:pseResponse error:error];
    NSArray *aid = [self getAidFromSFI:sfi error:error];
    NSArray *publicData =  [self readPublicDataForAID:aid error:error];
    return publicData;
}

-(NSArray *)readPublicDataViaAIDsError:(NSError **)error
{
    NSArray *aidList = [EmvAIDList list];
    NSArray *pd;
    for (int i = 0; i < aidList.count; i++) {
        CardAID *aid = aidList[i];
        NSArray *aidAsNSNumbersArray = aid.aid;
        NSArray *publicData = [self readPublicDataForAID:aidAsNSNumbersArray error:error];
        if (publicData) {
            pd = publicData;
            break;
        }
    }
    
    return nil;
}

-(NSArray *)readPublicDataForAID:(NSArray *)aid error:(NSError **)error
{
    if (!aid) {
        return nil;
    }
    
    RAPDU* selectAid = [self selectAID:aid error:error];
    
    NSArray *pdolBytes = [self.rapduParser PDOLFromRAPDU:selectAid error:error];
    
    if (pdolBytes) {
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Processing options data object list required by card." forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:ReadingPublicDataErrorDomain
                                    code:ReadingPublicDataErrorCodePDOLRequired
                                userInfo:details];
        return nil;
    }
    //continue if no PDOL is required
    RAPDU *processingOptionsResponse = [self getProcessingOptionsWithPDOL:@[@0x00] error:error];
    NSArray *sfisWithRanges = [self.rapduParser sfisWithRecordNumbersFromRAPDU:processingOptionsResponse error:error];
    if (!sfisWithRanges) {
        return nil;
    }
    NSArray *aflRecords = [self aflRecordsForSFIs:sfisWithRanges error:error];
    return aflRecords;
}

#pragma mark - APDU

-(RAPDU *)selectPSEDirError:(NSError **)error
{
    NSError *executionerError = nil;
    CAPDU *selectPSE = [CAPDUGenerator selectPSEDirectory];
    RAPDU *responsePSE = [self.deviceReader executeCommand:selectPSE error:&executionerError];
    responsePSE = [self executeCorrectedLengthCAPDU:selectPSE withRapdu:responsePSE error:&executionerError];
    
    if (!responsePSE) {
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"No PSE Dir found." forKey:NSLocalizedDescriptionKey];
        [details setValue:executionerError forKey:NSUnderlyingErrorKey];

        if (error) {
            *error = [NSError errorWithDomain:ReadingPublicDataErrorDomain code:2 userInfo:details];
        }
        return nil;
    }
    
    return responsePSE;
}

-(RAPDU *)selectPPSEDirError:(NSError **)error
{
    NSError *executionerError = nil;
    CAPDU *selectPPSE = [CAPDUGenerator selectPPSEDirectory];
    RAPDU *responsePPSE = [self.deviceReader executeCommand:selectPPSE error:&executionerError];
    responsePPSE = [self executeCorrectedLengthCAPDU:selectPPSE withRapdu:responsePPSE error:&executionerError];
    
    if (!responsePPSE) {
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"No PPSE Dir found." forKey:NSLocalizedDescriptionKey];
        [details setValue:executionerError forKey:NSUnderlyingErrorKey];
        if (error) {
            *error = [NSError errorWithDomain:ReadingPublicDataErrorDomain code:3 userInfo:details];
        }
        return nil;
    }
    

    return responsePPSE;
}

-(RAPDU *)selectAID:(NSArray *)aid error:(NSError **)error
{
    if (!aid) {
        return nil;
    }
    NSError *executionerError = nil;

    CAPDU *selectAid = [CAPDUGenerator selectApplicationWithAID:aid];
    RAPDU *selectAidResponse = [self.deviceReader executeCommand:selectAid error:&executionerError];
    selectAidResponse = [self executeCorrectedLengthCAPDU:selectAid withRapdu:selectAidResponse error:&executionerError];
    
    //TODO : add check if AID is contained in RAPDU
    if (!selectAidResponse) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[NSString stringWithFormat:@"Error selecting AID: %@", aid] forKey:NSLocalizedDescriptionKey];
        [details setValue:executionerError forKey:NSUnderlyingErrorKey];
        if (error) {
            *error = [NSError errorWithDomain:ReadingPublicDataErrorDomain code:ReadingPublicDataErrorCodeSelectAID userInfo:details];
        }
        return nil;
    }
    
    return selectAidResponse;
}

-(NSArray *)getAidFromSFI:(NSNumber *)sfi error:(NSError **)error
{
    if (!sfi) {
        return nil;
    }
    RAPDU *readRecordResponse = [self readRecordWithRecordNumber:@0x01 andSFI:sfi error:error];
    NSArray *aid = [self.rapduParser aidFromRAPDU:readRecordResponse error:error];
    return aid;
}

-(NSArray *)aflRecordsForSFIs:(NSArray *)sfiArray error:(NSError **)error
{
    NSMutableArray *records = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < sfiArray.count; i++) {
        
        SFIWithRecordNumbers *obj = sfiArray[i];
        for (NSUInteger j = [obj.firstRecordNumber unsignedIntegerValue]; j <= [obj.lastRecordNumber unsignedIntegerValue]; j++) {
            
            NSNumber *recordNumber = [NSNumber numberWithUnsignedInteger:j];
            RAPDU *responseFromRecord = [self readRecordWithRecordNumber:recordNumber andSFI:obj.sfi error:error];
            NSData *recordsData = [NSData byteDataFromArray:responseFromRecord.bytes];
            [records addObject:recordsData];
            NSLog(@"\n\n%@", [self.rapduParser berTlvParseData:recordsData]);
        }
    }
    
    return records;
}

-(RAPDU *)readRecordWithRecordNumber:(NSNumber *)recordNumber andSFI:(NSNumber *)sfi error:(NSError **)error
{
    if (!recordNumber || !sfi) {
        return nil;
    }
    //At first try Le is 0x00 to get the record location
    CAPDU *readRecord = [CAPDUGenerator readRecordWithRecordNumber:recordNumber SFI:sfi andLe:@0x00];
    RAPDU *responseReadRecord = [self.deviceReader executeCommand:readRecord error:error];
    responseReadRecord = [self executeCorrectedLengthCAPDU:readRecord withRapdu:responseReadRecord error:error];
    
    return responseReadRecord;
}

-(RAPDU *)getProcessingOptionsWithPDOL:(NSArray *)pdol
                                 error:(NSError **)error
{
    //TODO PDOL != @0x00
    CAPDU *getProceessingOptions = [CAPDUGenerator getProcessingOptionsWithPDOL:pdol];
    RAPDU *getProceessingOptionsResponse = [self.deviceReader executeCommand:getProceessingOptions error:error];
    getProceessingOptionsResponse = [self executeCorrectedLengthCAPDU:getProceessingOptions withRapdu:getProceessingOptionsResponse error:error];
    
    return getProceessingOptionsResponse;
}

//*Called after every CAPDU execution.
//If the response has 0x61 or 0x6C as the byte before last,
//a new CAPDU should be executed with the correct length, which is the last byte of the response
//*

-(RAPDU *)executeCorrectedLengthCAPDU:(CAPDU *)capdu withRapdu:(RAPDU *)rapdu error:(NSError **)error
{
    if (rapdu.bytes.count > 1) {
        
        NSNumber *byteBeforeLast = [rapdu byteBeforeLast];
        NSNumber *lastByte = [rapdu lastByte];
        
        if ([byteBeforeLast isEqual:@0x61]) {
            
            //response bytes still available
            CAPDU *commandToExecute = [CAPDUGenerator getResponseWithLength:lastByte];
            rapdu = [self.deviceReader executeCommand:commandToExecute error:error];
            
        }else if ([byteBeforeLast isEqual:@0x6C] || [byteBeforeLast isEqual:@0x67]){
            
            //same commmand, just fixed length
            CAPDU *commandToExecute = [CAPDUGenerator capduWithCAPDU:capdu withFixedLength:lastByte];
            rapdu = [self.deviceReader executeCommand:commandToExecute error:error];
            
        }
    }
    
    return rapdu;
}

@end
