//
//  CAPDUGenerator.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/17/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "CAPDUGenerator.h"
#import "CAPDU.h"

@implementation CAPDUGenerator

+(CAPDU *)selectPSEDirectory{
    
    NSString *pseDDF = @"1PAY.SYS.DDF01";
    const char *utf8Str = [pseDDF UTF8String];
    Byte *rawBytes = (unsigned char *)utf8Str;
    NSUInteger length = [pseDDF lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    Byte myLength = (Byte)length;
    
    CAPDU *selectPSE = [self selectApplicationWithAID:rawBytes withLength:myLength];
    return selectPSE;
}

+(CAPDU *)selectPPSEDirectory{
    
    NSString *pseDDF = @"2PAY.SYS.DDF01";
    const char *utf8Str = [pseDDF UTF8String];
    Byte *rawBytes = (unsigned char *)utf8Str;
    NSUInteger length = [pseDDF lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    Byte myLength = (Byte)length;
    
    CAPDU *selectPPSE = [self selectApplicationWithAID:rawBytes withLength:myLength];
    return selectPPSE;
}


+(CAPDU *)getResponseWithLength:(Byte)le
{
    CAPDU *getResponseCAPDU = [[CAPDU alloc] initWithCLA:0x00
                                                     INS:0xC0
                                                      p1:0x00
                                                      p2:0x00
                                  expectedResponseLength:le];
    
    return getResponseCAPDU;
}

+(CAPDU *)selectApplicationWithAID:(Byte *)aid
                        withLength:(Byte)commandLength
{
    CAPDU *selectAID = [[CAPDU alloc] initWithCLA:0x00
                                              INS:0xA4
                                               p1:0x04
                                               p2:0x00
                                    commandLength:commandLength
                                      commandData:aid];
    
    return selectAID;
}

+(CAPDU*)getProcessingOptionsWithPDOL:(Byte)PDOL
{
    Byte pdolCommand[] = {0x83, PDOL};
    CAPDU *getProcessingOptions = [[CAPDU alloc] initWithCLA:0x80
                                                         INS:0xA8
                                                          p1:0x00
                                                          p2:0x00
                                               commandLength:0x02
                                                 commandData:pdolCommand];
    
    return getProcessingOptions;
}

+(CAPDU *)readRecordWithRecordNumber:(Byte)recordNumber andSFI:(Byte)sfi
{
    //Le is 0x00 at first to get the record location
    CAPDU *readRecord = [[CAPDU alloc] initWithCLA:0x00
                                               INS:0xB2
                                                p1:recordNumber
                                                p2:sfi
                            expectedResponseLength:0x00];

    return readRecord;
}

@end
