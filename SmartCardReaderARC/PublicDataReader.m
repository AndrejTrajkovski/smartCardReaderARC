//
//  CommandProcessor.m
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import "PublicDataReader.h"
#import "PBSmartcard.h"
#import "CAPDU.h"
#import "RAPDU.h"
#import "NSArray+NSNumbersFromUnsignedCharArray.h"
#import "CAPDUGenerator.h"
#import "RAPDUParser.h"

@interface PublicDataReader()

@property (strong, nonatomic) RAPDUParser *rapduParser;

@end

@implementation PublicDataReader
{
}

-(instancetype)initWithSmartCard:(PBSmartcard *)smardCard
{
    self = [super init];
    if (self) {
        
        self.smartCard = smardCard;
        self.rapduParser = [RAPDUParser new];
    }
    return self;
}

-(void)selectPSEDir
{
    CAPDU *selectPSE = [CAPDUGenerator selectPSEDirectory];
    RAPDU *response = [self executeCommand:selectPSE];
    Byte sfi = [self.rapduParser sfiFromData:response.bytesAsData];
    
    CAPDU *readRecord = [CAPDUGenerator readRecordWithRecordNumber:0x01 andSFI:sfi];
    RAPDU *responseReadRecord = [self executeCommand:readRecord];
    NSArray *aidArray = [self.rapduParser aidFromData:responseReadRecord.bytesAsData];
    CAPDU *selectAid = [CAPDUGenerator selectApplicationWithAID:[aidArray cArrayFromBytes] withLength:(Byte)aidArray.count];
    RAPDU *selectAidResponse = [self executeCommand:selectAid];
    
}

-(void)selectPPSEDir
{
    CAPDU *selectPPSE = [CAPDUGenerator selectPPSEDirectory];
    RAPDU *reponse = [self executeCommand:selectPPSE];
}

-(void)selectAID
{
    unsigned char visaElctronAid[] = {0xA0, 0x00, 0x00, 0x00, 0x03, 0x20, 0x10};
    CAPDU *selectVisaElectronAid = [CAPDUGenerator selectApplicationWithAID:visaElctronAid withLength:0x07];
    RAPDU *selectAidResponse = [self executeCommand:selectVisaElectronAid];
}

-(RAPDU *)executeCommand:(CAPDU *)capdu
{
    static unsigned char buffer[255] = {0};
    unsigned char *command = [capdu.bytes cArrayFromBytes];
    unsigned short rdl;
    rdl = sizeof(buffer);
    for (int i = 0; i < capdu.bytes.count; i++) {
        printf("%02X \n", command[i]);
    }
    PBSmartcardStatus status = [self.smartCard transmit:command
                                      withCommandLength:capdu.bytes.count
                                      andResponseBuffer:buffer
                                      andResponseLength:&rdl];
    
    unsigned char *responseCArray = (unsigned char *)calloc(rdl, sizeof(unsigned char));
    int responseLength = (int)rdl;
    
    for (int i = 0; i < responseLength; i++) {
        responseCArray[i] = buffer[i];
    }
    
    Byte byteBeforeLast = responseCArray[rdl-2];
    Byte lastByte = responseCArray[rdl-1];
    
    if (byteBeforeLast == 0x61){
        
        Byte expectedLength = lastByte;
        CAPDU *getResponse = [CAPDUGenerator getResponseWithLength:expectedLength];
        return [self executeCommand:getResponse];
        
    }else if (byteBeforeLast == 0x6C){
        
        Byte correctLength = lastByte;
        [capdu replaceLengthByteWithCorrectLength:correctLength];
        return [self executeCommand:capdu];
        
    }else if (byteBeforeLast == 0x6D){
        
        //Instruction Code Error
    }

    RAPDU *responseAPDU = [[RAPDU alloc] initWithResponseBytes:responseCArray
                                                     andLength:responseLength
                                                     andStatus:status];
    
    return responseAPDU;
}

@end
