//
//  CommandProcessor.m
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import "CommandProcessor.h"
#import "PBSmartcard.h"
#import "CAPDU.h"
#import "RAPDU.h"
#import "NSArray+NSNumbersFromUnsignedCharArray.h"
#import "GetResponseCAPDU.h"

@interface CommandProcessor()

@property (strong, nonatomic) NSArray *commands;
@property (assign, nonatomic) NSInteger commandIndex;
@end

@implementation CommandProcessor
{
}

-(instancetype)initWithCommandFlow:(NSArray *)commands andSmartCard:(PBSmartcard *)smardCard
{
    self = [super init];
    if (self) {
        self.commands = commands;
        self.smartCard = smardCard;
        self.commandIndex = 0;
    }
    return self;
}

-(void)start
{
    CAPDU *commandToExecute = [self.commands objectAtIndex:self.commandIndex];
    [self executeCommand:commandToExecute];
    self.commandIndex ++;
}

-(RAPDU *)executeCommand:(CAPDU *)capdu
{
    unsigned char buffer[255] = {0};
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
    
    unsigned short byteBeforeLast = responseCArray[rdl-2];
    unsigned short lastByte = responseCArray[rdl-1];
    
    if (byteBeforeLast == 0x61){
        
        unsigned short expectedLength = lastByte;
        GetResponseCAPDU *getResponse = [[GetResponseCAPDU alloc] initWithExpectedLength:expectedLength];
        return [self executeCommand:getResponse];
        
    }else if (byteBeforeLast == 0x6C){
        
        unsigned short expectedLength = lastByte;
        GetResponseCAPDU *getResponse = [[GetResponseCAPDU alloc] initWithExpectedLength:expectedLength];
        
    }
    
    RAPDU *responseAPDU = [[RAPDU alloc] initWithResponseBytes:responseCArray
                                                     andLength:responseLength
                                                     andStatus:status];
    
    return responseAPDU;
}

@end
