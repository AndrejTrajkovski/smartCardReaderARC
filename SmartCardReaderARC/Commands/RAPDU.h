//
//  RAPDU.h
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import "APDU.h"

typedef enum {
    RAPDUStatusResponseBytesStillAvailable,
    RAPDUStatusWrongLength,
    RAPDUStatusOther,
    RAPDUStatusNoBytes,
    RAPDUStatusWrongP1P2,
    RAPDUStatusSuccess
} RAPDUStatus;

@interface RAPDU : NSObject <APDU>

-(instancetype)initWithResponseBytes:(unsigned char *)responseBytes
                           andLength:(int)length;

-(RAPDUStatus)responseStatus;
-(NSNumber *)lastByte;
-(NSNumber *)byteBeforeLast;
-(NSArray *)bytesWithoutStatus;

@end
