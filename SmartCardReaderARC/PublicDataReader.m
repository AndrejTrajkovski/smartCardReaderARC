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
{
}

-(instancetype)initWithExecutioner:(id<CardReaderCommandExecutioner>)commandExecutioner
{
    self = [super init];
    
    if (self) {
        
        self.rapduParser = [RAPDUParser new];
        self.commandExecutioner = commandExecutioner;
    }
    
    return self;
}

//*If the response has 0x61 or 0x6C as the byte before last, a new CAPDU should be send with the correct length, which is the last byte of the response
-(RAPDU *)executeCorrectedLengthCAPDU:(CAPDU *)capdu withRapdu:(RAPDU *)rapdu
{
    if (rapdu.bytes.count > 1) {
        
        NSNumber *byteBeforeLast = rapdu.bytes[rapdu.bytes.count - 2];
        NSNumber *lastByte = rapdu.bytes[rapdu.bytes.count - 1];

        if ([byteBeforeLast isEqual:@0x61]) {
            
            CAPDU *commandToExecute = [CAPDUGenerator getResponseWithLength:lastByte];
            rapdu = [self.commandExecutioner executeCommand:commandToExecute];

        }else if ([byteBeforeLast isEqual:@0x6C]){
            
            CAPDU *commandToExecute = [CAPDUGenerator capduWithCAPDU:capdu withFixedLength:lastByte];
            rapdu = [self.commandExecutioner executeCommand:commandToExecute];
            
        }
    }
    
    return rapdu;
}

-(void)readPublicDataViaPSE
{
    RAPDU *pseResponse = [self selectPSEDir];
    
    NSNumber* sfi = [self.rapduParser sfiFromRAPDU:pseResponse];
    
    RAPDU *readRecordResponse = [self readRecordWithRecordNumber:@0x01 andSFI:sfi];
    
    NSArray *aid = [self.rapduParser aidFromRAPDU:readRecordResponse];
    
    [self selectAID:aid];
    
    RAPDU *processingOptionsResponse = [self getProcessingOptionsWithPDOL:@0x00];
    
    NSArray *sfisWithRanges = [self.rapduParser sfisWithRecordNumbersFromRAPDU:processingOptionsResponse];
    
    [sfisWithRanges enumerateObjectsUsingBlock:^(SFIWithRecordNumbers*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSLog(@"READING FOR SFI : %@ \n", obj.sfi);
        
        for (NSUInteger i = [obj.firstRecordNumber unsignedIntegerValue]; i <= [obj.lastRecordNumber unsignedIntegerValue]; i++) {

            NSNumber *recordNumber = [NSNumber numberWithUnsignedInteger:i];
            RAPDU *responseFromRecord = [self readRecordWithRecordNumber:recordNumber andSFI:obj.sfi];

            NSLog(@"\t RECORD NUMBER : %@ \n", recordNumber);
            NSData *recordsData = [NSData byteDataFromArray:responseFromRecord.bytes];
            NSLog(@"\t RECORD NUMBER : %@ \n", [HexUtil prettyFormat:recordsData]);
        }
    }];
    
}

-(RAPDU *)getProcessingOptionsWithPDOL:(NSNumber *)pdol
{
    CAPDU *getProceessingOptions = [CAPDUGenerator getProcessingOptionsWithPDOL:pdol];
    RAPDU *getProceessingOptionsResponse = [self.commandExecutioner executeCommand:getProceessingOptions];
    getProceessingOptionsResponse = [self executeCorrectedLengthCAPDU:getProceessingOptions withRapdu:getProceessingOptionsResponse];
    
    return getProceessingOptionsResponse;
}

-(RAPDU *)readRecordWithRecordNumber:(NSNumber *)recordNumber andSFI:(NSNumber *)sfi
{
    CAPDU *readRecord = [CAPDUGenerator readRecordWithRecordNumber:recordNumber andSFI:sfi];
    RAPDU *responseReadRecord = [self.commandExecutioner executeCommand:readRecord];
    responseReadRecord = [self executeCorrectedLengthCAPDU:readRecord withRapdu:responseReadRecord];
    
    return responseReadRecord;
}

-(RAPDU *)selectPSEDir
{
    CAPDU *selectPSE = [CAPDUGenerator selectPSEDirectory];
    RAPDU *responsePSE = [self.commandExecutioner executeCommand:selectPSE];
    responsePSE = [self executeCorrectedLengthCAPDU:selectPSE withRapdu:responsePSE];
    
    return responsePSE;
}

-(RAPDU *)selectPPSEDir
{
    CAPDU *selectPPSE = [CAPDUGenerator selectPPSEDirectory];
    RAPDU *responsePPSE = [self.commandExecutioner executeCommand:selectPPSE];
    responsePPSE = [self executeCorrectedLengthCAPDU:selectPPSE withRapdu:responsePPSE];
    
    return responsePPSE;
}

-(RAPDU *)selectAID:(NSArray *)aid
{
    CAPDU *selectAid = [CAPDUGenerator selectApplicationWithAID:aid];
    RAPDU *selectAidResponse = [self.commandExecutioner executeCommand:selectAid];
    selectAidResponse = [self executeCorrectedLengthCAPDU:selectAid withRapdu:selectAidResponse];
    
    return selectAidResponse;
}

@end
