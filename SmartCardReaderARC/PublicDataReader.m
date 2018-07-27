//
//  CommandProcessor.m
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import "PublicDataReader.h"
#import "CAPDU.h"
#import "RAPDU.h"
#import "CAPDUGenerator.h"
#import "RAPDUParser.h"
#import "HexUtil.h"
#import "NSData+ByteManipulation.h"

@interface PublicDataReader()

@property (strong, nonatomic) RAPDUParser *rapduParser;

@end

@implementation PublicDataReader

#pragma mark - Initialization

-(instancetype)initWithExecutioner:(id<CardReaderCommandExecutioner>)commandExecutioner
{
    self = [super init];
    
    if (self) {
        
        self.rapduParser = [RAPDUParser new];
        self.commandExecutioner = commandExecutioner;
    }
    
    return self;
}

#pragma mark - Read Public Data

//TODO fix no SFI from parsing
-(NSString *)readPublicDataViaPPSEWithError:(NSError **)error
{
    RAPDU *ppseResponse = [self selectPPSEDirError:error];
    NSArray *aid = [self.rapduParser aidFromRAPDU:ppseResponse error:error];
    if (!aid) {
        NSNumber* sfi = [self.rapduParser sfiFromRAPDU:ppseResponse error:error];
        aid = [self getAidFromSFI:sfi error:error];
    }
    
    NSString *publicData =  [self readPublicDataForAID:aid error:error];
    return publicData;
}

-(NSString *)readPublicDataViaPSEWithError:(NSError **)error
{
    RAPDU *pseResponse = [self selectPSEDirError:error];
    NSNumber* sfi = [self.rapduParser sfiFromRAPDU:pseResponse error:error];
    NSArray *aid = [self getAidFromSFI:sfi error:error];
    NSString *publicData =  [self readPublicDataForAID:aid error:error];
    return publicData;
}

-(NSString *)readPublicDataForAID:(NSArray *)aid error:(NSError **)error
{
    if (!aid) {
        return nil;
    }
    BOOL selectAIDSuccess = [self selectAID:aid error:error];
    if (!selectAIDSuccess) {
        return nil;
    }
    NSString *aflRecords = [self readAFLRecordsFromSelectedAIDError:error];
    return aflRecords;
}

#pragma mark - APDU

-(RAPDU *)selectPSEDirError:(NSError **)error
{
    CAPDU *selectPSE = [CAPDUGenerator selectPSEDirectory];
    RAPDU *responsePSE = [self.commandExecutioner executeCommand:selectPSE error:error];
    responsePSE = [self executeCorrectedLengthCAPDU:selectPSE withRapdu:responsePSE error:error];
    
    if (!responsePSE) {
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"." forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:@"Error Reading From Card" code:200 userInfo:details];
        }
        return nil;
    }
    
    return responsePSE;
}

-(RAPDU *)selectPPSEDirError:(NSError **)error
{
    CAPDU *selectPPSE = [CAPDUGenerator selectPPSEDirectory];
    RAPDU *responsePPSE = [self.commandExecutioner executeCommand:selectPPSE error:error];
    responsePPSE = [self executeCorrectedLengthCAPDU:selectPPSE withRapdu:responsePPSE error:error];
    
    return responsePPSE;
}

-(BOOL)selectAID:(NSArray *)aid error:(NSError **)error
{
    if (!aid) {
        return nil;
    }
    CAPDU *selectAid = [CAPDUGenerator selectApplicationWithAID:aid];
    RAPDU *selectAidResponse = [self.commandExecutioner executeCommand:selectAid error:error];
    selectAidResponse = [self executeCorrectedLengthCAPDU:selectAid withRapdu:selectAidResponse error:error];
    
    if (selectAidResponse.responseStatus != RAPDUStatusSuccess) {
        //TODO : add check if AID is contained in RAPDU
        return NO;
    }
    
    return YES;
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

-(NSString *)readAFLRecordsFromSelectedAIDError:(NSError **)error
{
    RAPDU *processingOptionsResponse = [self getProcessingOptionsWithPDOL:@0x00 error:error];
    NSArray *sfisWithRanges = [self.rapduParser sfisWithRecordNumbersFromRAPDU:processingOptionsResponse error:error];
    if (!sfisWithRanges) {
        return nil;
    }
    
    NSMutableString *records = [NSMutableString new];
    
    for (NSUInteger i = 0; i < sfisWithRanges.count; i++) {
        
        SFIWithRecordNumbers *obj = sfisWithRanges[i];
        for (NSUInteger j = [obj.firstRecordNumber unsignedIntegerValue]; j <= [obj.lastRecordNumber unsignedIntegerValue]; j++) {
            
            NSNumber *recordNumber = [NSNumber numberWithUnsignedInteger:j];
            RAPDU *responseFromRecord = [self readRecordWithRecordNumber:recordNumber andSFI:obj.sfi error:error];
            NSData *recordsData = [NSData byteDataFromArray:responseFromRecord.bytes];
            NSString *oneRecordString = [self.rapduParser berTlvParseData:recordsData];
            [records appendString:oneRecordString];
            NSLog(@"\n\n%@", [self.rapduParser berTlvParseData:recordsData]);
        }
    }
    
    return records;
}

-(RAPDU *)readRecordWithRecordNumber:(NSNumber *)recordNumber andSFI:(NSNumber *)sfi error:(NSError **)error
{
    //At first try Le is 0x00 to get the record location
    CAPDU *readRecord = [CAPDUGenerator readRecordWithRecordNumber:recordNumber SFI:sfi andLe:@0x00];
    RAPDU *responseReadRecord = [self.commandExecutioner executeCommand:readRecord error:error];
    responseReadRecord = [self executeCorrectedLengthCAPDU:readRecord withRapdu:responseReadRecord error:error];
    
    return responseReadRecord;
}

-(RAPDU *)getProcessingOptionsWithPDOL:(NSNumber *)pdol error:(NSError **)error
{
    //TODO PDOL != @0x00
    CAPDU *getProceessingOptions = [CAPDUGenerator getProcessingOptionsWithPDOL:pdol];
    RAPDU *getProceessingOptionsResponse = [self.commandExecutioner executeCommand:getProceessingOptions error:error];
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
            rapdu = [self.commandExecutioner executeCommand:commandToExecute error:error];
            
        }else if ([byteBeforeLast isEqual:@0x6C] || [byteBeforeLast isEqual:@0x67]){
            
            //same commmand, just fixed length
            CAPDU *commandToExecute = [CAPDUGenerator capduWithCAPDU:capdu withFixedLength:lastByte];
            rapdu = [self.commandExecutioner executeCommand:commandToExecute error:error];
            
        }
    }
    
    return rapdu;
}

@end
