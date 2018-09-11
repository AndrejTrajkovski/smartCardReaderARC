//
//  BLENfcReader.h
// 
//
//  Created by Nefcom Tech on 15/11/17.
//
//
#import <CoreBluetooth/CoreBluetooth.h>
#import "CCIDReader.h"
#import "BLEReader.h"

#define CARD_TYPE_ISO1443A 0x00

@interface BLENfcReader : BLEReader {
@private
    BOOL _activeCard;
}

- (id) connectCard: (NSString *) cls cardType:(int)type;
- (NSData*) connectCard:(int)cardType;
@end
