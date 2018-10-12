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
    CAPDU *fixedLengthCAPDU = [[CAPDU alloc] initWithCAPDU:capdu];
    
    [fixedLengthCAPDU replaceLengthByteWithCorrectLength:le];
    
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

+(CAPDU *)getProcessingOptionsWithPDOL:(NSArray *)PDOL
{
    NSMutableArray *pdolCommand = [NSMutableArray new];
    [pdolCommand addObjectsFromArray:PDOL];
    [pdolCommand insertObject:@0x83 atIndex:0];
    
    CAPDU *getProcessingOptions = [[CAPDU alloc] initWithCLA:@0x80
                                                         INS:@0xA8
                                                          p1:@0x00
                                                          p2:@0x00
                                                 commandData:pdolCommand];
    
    return getProcessingOptions;
}

+(CAPDU *)readRecordWithRecordNumber:(NSNumber *)recordNumber SFI:(NSNumber *)sfi andLe:(NSNumber *)le
{
    CAPDU *readRecord = [[CAPDU alloc] initWithCLA:@0x00
                                               INS:@0xB2
                                                p1:recordNumber
                                                p2:sfi
                            expectedResponseLength:le];

    return readRecord;
}

#pragma mark - EID

+(CAPDU *)selectEmiratesCardFileWithFID:(NSArray *)fid
{
    CAPDU *readRecord = [[CAPDU alloc] initWithCLA:@0x00
                                               INS:@0xA4
                                                p1:@0x00
                                                p2:@0x00
                                       commandData:fid];
    
    return readRecord;
}

+(CAPDU *)readEmiratesCardFileWithOffset:(NSInteger)offset
                               andLength:(NSInteger)length
{
    NSNumber *p1 = [NSNumber numberWithLong:offset / 0x100];
    NSNumber *p2 = [NSNumber numberWithLong:offset % 0x100];
    NSNumber *le = [NSNumber numberWithInt:length];
    
    NSLog(@"offset : %lu \n p1 : %@ \n p2 : %@", offset, p1, p2);
    
    CAPDU *readRecord = [[CAPDU alloc] initWithCLA:@0x00
                                               INS:@0xB0
                                                p1:p1
                                                p2:p2
                            expectedResponseLength:le];
    
    return readRecord;
}

@end
