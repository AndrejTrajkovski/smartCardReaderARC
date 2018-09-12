//
//  BLENfcReader.h
// 
//
//  Created by Nefcom Tech on 12/12/24.
//
//
#import <CoreBluetooth/CoreBluetooth.h>
//#import <CoreBluetooth/CBCentralManager.h>
//#import <CoreBluetooth/CBPeripheral.h>
//#import <CoreBluetooth/CBCharacteristic.h>
//#import <CoreBluetooth/CBDescriptor.h>
//#import <CoreBluetooth/CBService.h>
//#import <CoreBluetooth/CBUUID.h>

#import "CCIDReader.h"
/*
enum packetType: int {
    PACKET_RAW = 0,
    PACKET_CCID = 1
} packetType;

enum {
    LE_STATUS_IDLE = 0,
    LE_STATUS_SCANNING,
    LE_STATUS_CONNECTING,
    LE_STATUS_CONNECTED
};*/

#define BUFFER_SIZE 296

@protocol BLEReaderDelegate;
@interface BLEReader : CCIDReader <CBCentralManagerDelegate, CBPeripheralDelegate> {
    
    enum packetType: int {
        PACKET_RAW = 0,
        PACKET_CCID = 1
    } packetType;
    
    enum {
        LE_STATUS_IDLE = 0,
        LE_STATUS_SCANNING,
        LE_STATUS_CONNECTING,
        LE_STATUS_CONNECTED
    };

    
@private
@protected
    //id <BLEReaderDelegate> delegate;
    
    BOOL _waitFlag;
    int _connectionStatus;
    
    /* for discovery devices */
    CBCentralManager *_manager;
    NSMutableArray *_devicesList;
    
    CBPeripheral *_peripheral;
    
    //mark by roman 20150921
    //no use
    //CFUUIDRef _peripheralUUID;
    //CFStringRef _peripheralUUIDStr;
    
    //int serviceUUID;
    CBCharacteristic *_charForWrite;
    CBCharacteristic *_charForRead;
    CBCharacteristic *_charForPatch;
    
    //error
    NSInteger _error;
    NSString* _errorDesc;
    
    int _packetType;
    int _expectedLen;
    uint8_t _buffer[BUFFER_SIZE];
    int _bufferLen;

}

@property(assign) id <BLEReaderDelegate> delegate;

/* Buffer management for receiving data */
- (void) resetBuffer;
-(void) putBuffer:(uint8_t *) inData inLen:(long)len;
-(BOOL) checkBuffer;

-(void) wait:(int) secs;
-(void) notify;
- (uint8_t) getLRC:(const uint8_t *) data length:(int)len;


//Pubic methods
- (void) scanForReaders;
- (void) scanForReaders:(int) not_found_timeout;
- (void) stopScan;

- (int) openByUUID: (NSString *) uuid;
- (int) openByIndex: (int) index;

- (int) openByUUID: (NSString *) uuid timeout:(int) seconds;
- (int) openByIndex: (int) index timeout:(int) seconds;

- (void) close:(int) timeout;
//- (void) openWithUUID: (CFStringRef) UUID;
- (int) write:(const NSData*) data;
-(NSData*) read:(int)expectedLen timeout:(int) seconds;

@end


@protocol BLEReaderDelegate <NSObject>
@required
- (void) didDiscoverReader:(NSString *)name UUID:(NSString *) uuid index:(int) idx;

@optional
- (void) didConnectReader:(NSError *)error;
- (void) didFailToConnectReader:(NSError *)error;
- (void) didDisconnectReader:(NSError *)error;
- (void) didReaderNotFound;

@end
