//
//  Card.h
//  MFi_SPP
//
//  Created by Nefcom Tech on 13/1/2.
//
//

#import <Foundation/Foundation.h>
#import "CCIDReader.h"

@class CCIDReader;
@class APDUCommand;

@interface Card : NSObject
{
    NSData* _atr;
    CCIDReader* _reader;
}

- (id)initWithReader:(CCIDReader *)Reader;
- (BOOL) identifyCard:(uint8_t *) atrData length:(int)len;
- (void) setTimeout:(int) second;

- (void) disConnectCard;
- (int) trasnmit:(uint8_t *) inData inLen:(int)inLen outData:(uint8_t *) outData outLen:(int)outLen;
- (NSData*) trasnmit:(APDUCommand*) cmd;
- (NSData*) select:(uint8_t *) data length:(int)len;

- (NSString*) readCard;

@end
