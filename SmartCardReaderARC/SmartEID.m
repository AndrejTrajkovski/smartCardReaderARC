#import "SmartEID.h"

#import <ExternalAccessory/ExternalAccessory.h>

#import "NotificationConstants.h"

#import "EMVReader.h"
#import "EIDReader.h"

#import "TactivoDeviceReader.h"
#import "NefcomDeviceReader.h"
#import "FeitianDeviceReader.h"

@interface SmartEID() <PDReaderDelegate>

@property (strong, nonatomic) id<PDReader> reader;

@end

@implementation SmartEID

#pragma mark - Init

- (instancetype)initWithDelegate:(id <SmartEIDDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self startListeningDeviceEvents];
        [self startListeningCardEvents];
    }
    return self;
}

#pragma mark - PDReaderDelegate

-(void)didReadPublicData:(id)publicDataRecords
{
    NSLog(@"public data : %@", publicDataRecords);
    [self.delegate didReadPublicData:publicDataRecords];
}

-(void)didFailToReadPublicDataWithError:(NSError *)error
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:@"Failed when preparing card." forKey:NSLocalizedDescriptionKey];
    [details setValue:error forKey:NSUnderlyingErrorKey];
    
    NSError *newError = [NSError errorWithDomain:ReadingPublicDataErrorDomain
                                            code:ReadingPublicDataErrorCodeWhenPreparingCard
                                        userInfo:details];
    [self.delegate didFailReadPublicData:newError];
}

#pragma mark - Listen to Device Inserts

-(void)startListeningDeviceEvents
{
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessoryDidConnect:)
                                                 name:EAAccessoryDidConnectNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessoryDidDisconnect:)
                                                 name:EAAccessoryDidDisconnectNotification
                                               object:nil];
}

-(void)stopListeningDeviceEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EAAccessoryDidConnectNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EAAccessoryDidDisconnectNotification
                                                  object:nil];
    [[EAAccessoryManager sharedAccessoryManager] unregisterForLocalNotifications];
}

-(void)accessoryDidConnect:(NSNotification *)notification
{
    [self.delegate didConnectDeviceReader];
    [self readPublicDataFromAccessory:[notification.userInfo objectForKey:EAAccessoryKey]];
}

-(void)accessoryDidDisconnect:(NSNotification *)notification
{
    [self.delegate didDisonnectDeviceReader];
}

#pragma mark - Listen to Card Inserts

-(void)startListeningCardEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didInsertCard:)
                                                 name:DidInsertCardNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRemoveCard:)
                                                 name:DidRemoveCardNotification
                                               object:nil];
}

-(void)stopListeningCardEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:DidInsertCardNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:DidRemoveCardNotification
                                                  object:nil];
}

-(void)didInsertCard:(NSNotification *)notification
{
    [self readPublicData];
    [self.delegate didInsertCard];
}

-(void)didRemoveCard:(NSNotification *)notification
{
    [self.delegate didRemoveCard];
}

-(CardType)currentCardType
{
    //TODO
    return CardTypeEID;
}

#pragma mark - Read EMV

-(void)readPublicData
{
    NSPredicate *recognizedReaderPredicate = [NSPredicate predicateWithBlock:^BOOL(EAAccessory *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [self deviceTypeFromAccessory:evaluatedObject] != ReaderDeviceTypeNotRecognized;
    }];
    EAAccessory *recognizedAccessory = [[[[EAAccessoryManager sharedAccessoryManager] connectedAccessories] filteredArrayUsingPredicate:recognizedReaderPredicate] firstObject];
    
    [self readPublicDataFromAccessory:recognizedAccessory];
}

-(void)readPublicDataFromAccessory:(EAAccessory *)accessory
{
    ReaderDeviceType typeOfConnectedDevice = [self deviceTypeFromAccessory:accessory];
    [self readPublicDataForDeviceType:typeOfConnectedDevice andCardType:self.currentCardType];
}

-(void)readPublicDataForDeviceType:(ReaderDeviceType)deviceType andCardType:(CardType)cardType
{
    id<DeviceReader> deviceReader = [self readerForDeviceType:deviceType];
    id<PDReader> publicDataReader;
    
    switch (cardType) {
        case CardTypeNoCard:
            publicDataReader = nil;
            break;
        case CardTypeEMV:
            publicDataReader = [[EMVReader alloc] initWithDeviceReader:deviceReader
                                                      andDelegate:self];
            break;
        case CardTypeEID:
            publicDataReader = [[EIDReader alloc] initWithDeviceReader:deviceReader
                                                      andDelegate:self];
            break;
        default:
            publicDataReader = nil;
            break;
    }
    
    
    if (!publicDataReader) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Device type not recognized." forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"Hardware error"
                                     code:123
                                 userInfo:details];
        [self.delegate didFailReadPublicData:error];
    }
    
    self.reader = publicDataReader;
    [self.reader readPublicData];
}

#pragma mark - Choose device type strategy

-(ReaderDeviceType)deviceTypeFromAccessory:(EAAccessory *)accessory
{
    if ([accessory.protocolStrings containsObject:@"com.keyxentic.kxpos01"]) {
        
        return ReaderDeviceTypeNefcom;
        
    }else if ([accessory.protocolStrings containsObject:@"com.precisebiometrics.ccidcontrol"]) {
        
        return ReaderDeviceTypeTactivo;
        
    }else if ([accessory.protocolStrings containsObject:@"com.ftsafe.iR301"]) {
        
        return ReaderDeviceTypeFeitian;
        
    }else{
        
        return ReaderDeviceTypeNotRecognized;
    }
}

-(id<DeviceReader>)readerForDeviceType:(ReaderDeviceType)deviceType
{
    switch (deviceType) {
            case ReaderDeviceTypeNotRecognized:
            return nil;
        case ReaderDeviceTypeNefcom:
            return [NefcomDeviceReader new];
            break;
        case ReaderDeviceTypeTactivo:
            return [TactivoDeviceReader new];
            break;
        case ReaderDeviceTypeFeitian:
            return [FeitianDeviceReader new];
            break;
    }
}

#pragma mark - Dealloc

-(void)dealloc
{
    [self stopListeningDeviceEvents];
    [self stopListeningCardEvents];
}

@end
