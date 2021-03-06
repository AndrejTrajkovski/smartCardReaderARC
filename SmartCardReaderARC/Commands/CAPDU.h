#import "APDU.h"

@interface CAPDU : NSObject <APDU>

-(instancetype)initWithCAPDU:(CAPDU *)capdu;

-(instancetype)initWithCLA:(NSNumber*)cla
                       INS:(NSNumber*)ins
                        p1:(NSNumber*)p1
                        p2:(NSNumber*)p2;

-(instancetype)initWithCLA:(NSNumber*)cla
                       INS:(NSNumber*)ins
                        p1:(NSNumber*)p1
                        p2:(NSNumber*)p2
    expectedResponseLength:(NSNumber*)le;

-(instancetype)initWithCLA:(NSNumber*)cla
                       INS:(NSNumber*)ins
                        p1:(NSNumber*)p1
                        p2:(NSNumber*)p2
               commandData:(NSArray*)commandData;

-(instancetype)initWithCLA:(NSNumber*)cla
                       INS:(NSNumber*)ins
                        p1:(NSNumber*)p1
                        p2:(NSNumber*)p2
               commandData:(NSArray*)commandData
    expectedResponseLength:(NSNumber*)le;

-(void)replaceLengthByteWithCorrectLength:(NSNumber*)le;

@end
