//
//  CAPDUGenerator.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/17/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "CAPDUGenerator.h"
#import "CAPDU.h"
#import "NSArray+ByteManipulation.h"

@implementation CAPDUGenerator

+(CAPDU *)selectPSEDirectory{
    
    NSString *pseDDF = @"1PAY.SYS.DDF01";
    NSArray *pseBytes = [NSArray byteArrayFromString:pseDDF];
    CAPDU *selectPSE = [self selectApplicationWithAID:pseBytes];
    return selectPSE;
}

+(CAPDU *)selectPPSEDirectory{
    
    NSString *ppseDDF = @"2PAY.SYS.DDF01";
    NSArray *ppseBytes = [NSArray byteArrayFromString:ppseDDF];
    CAPDU *selectPPSE = [self selectApplicationWithAID:ppseBytes];
    return selectPPSE;
}


+(CAPDU *)getResponseWithLength:(NSNumber *)le
{
    CAPDU *getResponseCAPDU = [[CAPDU alloc] initWithCLA:@0x00
                                                     INS:@0xC0
                                                      p1:@0x00
                                                      p2:@0x00
                                  expectedResponseLength:le];
    
    return getResponseCAPDU;
}

+(CAPDU *)capduWithCAPDU:(CAPDU *)capdu withFixedLength:(NSNumber *)le
{
    CAPDU *fixedLengthCAPDU = [[CAPDU alloc] initWithCLA:capdu.cla
                                                     INS:capdu.ins
                                                      p1:capdu.p1
                                                      p2:capdu.p2];
    fixedLengthCAPDU.le = le;
    
    return fixedLengthCAPDU;
}

+(CAPDU *)selectApplicationWithAID:(NSArray*)aid
{
    CAPDU *selectAID = [[CAPDU alloc] initWithCLA:@0x00
                                              INS:@0xA4
                                               p1:@0x04
                                               p2:@0x00
                                      commandData:aid];
    
    return selectAID;
}

+(CAPDU*)getProcessingOptionsWithPDOL:(NSNumber *)PDOL
{
    NSArray *pdolCommand = @[@0x83, PDOL];
    CAPDU *getProcessingOptions = [[CAPDU alloc] initWithCLA:@0x80
                                                         INS:@0xA8
                                                          p1:@0x00
                                                          p2:@0x00
                                                 commandData:pdolCommand];
    
    return getProcessingOptions;
}

+(CAPDU *)readRecordWithRecordNumber:(NSNumber *)recordNumber andSFI:(NSNumber *)sfi
{
    //Le is 0x00 at first to get the record location
    CAPDU *readRecord = [[CAPDU alloc] initWithCLA:@0x00
                                               INS:@0xB2
                                                p1:recordNumber
                                                p2:sfi
                            expectedResponseLength:@0x00];

    return readRecord;
}

@end
