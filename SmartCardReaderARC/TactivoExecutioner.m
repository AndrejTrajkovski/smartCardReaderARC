//
//  TactivoExecutioner.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/18/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "TactivoExecutioner.h"
#import "PBSmartcard.h"
#import "CardReaderCommandExecutioner.h"
#import "CAPDU.h"
#import "RAPDU.h"
#import "NSArray+ByteManipulation.h"
#import "RAPDUParser.h"
#import "CAPDUGenerator.h"

@interface TactivoExecutioner()

@property (strong, nonatomic) RAPDUParser *rapduParser;


@end

@implementation TactivoExecutioner

-(void)doInitialization
{
    self.rapduParser = [RAPDUParser new];

    self.smartCard = [[PBSmartcard alloc] init];
    PBSmartcardStatus status;
    
    status = [self.smartCard open];
    status = [self.smartCard connect:PBSmartcardProtocolTx];
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
    
    int responseLength = (int)rdl;
    
    Byte byteBeforeLast = buffer[rdl-2];
    Byte lastByte = buffer[rdl-1];
    
    if (byteBeforeLast == 0x61){
        
        NSNumber *correctLength = [NSNumber numberWithUnsignedChar:lastByte];
        CAPDU *getResponse = [CAPDUGenerator getResponseWithLength:correctLength];
        return [self executeCommand:getResponse];
        
    }else if (byteBeforeLast == 0x6C){
        
        NSNumber *correctLength = [NSNumber numberWithUnsignedChar:lastByte];
        [capdu replaceLengthByteWithCorrectLength:correctLength];
        return [self executeCommand:capdu];
        
    }else if (byteBeforeLast == 0x6D){
        
        //Instruction Code Error
    }
    
    RAPDU *responseAPDU = [[RAPDU alloc] initWithResponseBytes:buffer
                                                     andLength:responseLength
                                                     andStatus:status];
    
    return responseAPDU;
}


@end
