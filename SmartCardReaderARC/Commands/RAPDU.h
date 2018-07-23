//
//  RAPDU.h
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import "APDU.h"
#import "PBSmartcard.h"

typedef enum {
    RAPDUStatusResponseBytesStillAvailable,
    RAPDUStatusWrongLength,
    RAPDUStatusOther,
    RAPDUStatusNoBytes,
    RAPDUStatusSuccess
} RAPDUStatus;

@interface RAPDU : NSObject <APDU>

-(RAPDUStatus)responseStatus;
@property (assign, nonatomic) PBSmartcardStatus status;
-(instancetype)initWithResponseBytes:(unsigned char *)responseBytes
                           andLength:(int)length
                           andStatus:(PBSmartcardStatus)status;

-(NSNumber *)lastByte;
-(NSNumber *)byteBeforeLast;

@end
