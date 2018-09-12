//
//  CCIDReader.h
//  MFi_SPP
//
//  Created by Nefcom Tech on 12/12/24.
//
//

#import <Foundation/Foundation.h>
#import "Card.h"


#define MAX_COMMAND_LENGHT  287
@interface APDUCommand : NSObject
{
    char * name;
    uint8_t _buffer[MAX_COMMAND_LENGHT];
    int _length;
    int8_t _le;
    bool setLe;
    short swExpected;
    short swFilter;
    short sw1sw2; //APDU command status responded from card
    
}
@property char* name;
@property short swExpected;
@property short swFilter;
@property short sw1sw2;

- (void) setCLA:(uint8_t ) cla;
- (void) setINS:(uint8_t ) ins;
- (void) setP1:(uint8_t ) p1;
- (void) setP2:(uint8_t ) p2;
- (void) setLe:(uint8_t ) Le;
- (void) setData:(uint8_t *) data length:(int)len;

- (int) length;
- (uint8_t*) cmd;
@end

enum CardEvent {
	DETECTED = 0,
	REMOVED = 1
};

#define LOG_APDU    0x01
#define LOG_BT      0x02

#define T0_PROTOCOL 1
#define T1_PROTOCOL 2

#define MAX_READ_BUFFER 512
@interface CCIDReader : NSObject {
@private
    uint8_t _slot; //Slot Index
    uint8_t _sequence;
    uint8_t _protocol;
@protected
    int _activeProtocol;
    int _timeout;
    int _logLevel;
    short _sw1sw2;
    
}

@property(nonatomic, assign) int logLevel;
@property(nonatomic, assign) short sw1sw2;
@property(readonly, nonatomic, copy) NSString* name;

- (void) logData:(int) logLevel format:(NSString *)format, ... ;
- (void) logData:(const uint8_t *) data length:(int)len;
- (void) logData:(char *) title data:(const uint8_t *) data length:(int)len;

//- (NSMutableArray*) getReaders:(int) timeout;
- (id) getReaders;
- (id) getReaders:(int) timeout;
- (int) open;
- (void) close;
- (void) setTimeout:(int) second;
- (int) write:(const uint8_t *) inData inLen:(int)len;
- (int) read:(uint8_t *) outData outLen:(int)len;
- (int) powerOn:(uint8_t *) atrData maxLength:(int)maxLen;
- (void) powerOff;
- (int) getSlotStatus;
- (int) trasnmit:(uint8_t *) inData inLen:(int)inLen outData:(uint8_t *) outData outLen:(int)outLen;
- (NSData*) trasnmit:(APDUCommand*) cmd;
- (BOOL) isCardPresent;
- (NSData*) connectCard;
- (id) connectCard: (NSString *) cls;
- (void) disConnectCard;
@end
