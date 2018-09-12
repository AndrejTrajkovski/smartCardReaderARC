//
//  SmartEID.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 9/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

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

#pragma mark - Listen to Devices

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
    [self readEMVPublicDataFromAccessory:[notification.userInfo objectForKey:EAAccessoryKey]];
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
    [self readEMVPublicData];
    [self.delegate didInsertCard];
}

-(void)didRemoveCard:(NSNotification *)notification
{
    [self.delegate didRemoveCard];
}

-(CardType)currentCardType
{
    //TODO
    return CardTypeNoCard;
}

#pragma mark - Implementation

-(void)readEMVPublicData
{
    NSPredicate *recognizedReaderPredicate = [NSPredicate predicateWithBlock:^BOOL(EAAccessory *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [self deviceTypeFromAccessory:evaluatedObject] != ReaderDeviceTypeNotRecognized;
    }];
    EAAccessory *recognizedAccessory = [[[[EAAccessoryManager sharedAccessoryManager] connectedAccessories] filteredArrayUsingPredicate:recognizedReaderPredicate] firstObject];
    
    [self readEMVPublicDataFromAccessory:recognizedAccessory];
}

-(void)readEMVPublicDataFromAccessory:(EAAccessory *)accessory
{
    ReaderDeviceType typeOfConnectedDevice = [self deviceTypeFromAccessory:accessory];
    [self readEMVPublicDataForDeviceType:typeOfConnectedDevice];
}

-(void)readEMVPublicDataForDeviceType:(ReaderDeviceType)deviceType
{
    self.reader = [[EMVReader alloc] initWithDeviceReader:[self readerForDeviceType:deviceType]
                                              andDelegate:self];
    if (!self.reader) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Device type not recognized." forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"Hardware error"
                                     code:123
                                 userInfo:details];
        [self.delegate didFailReadPublicData:error];
    }
    [self.reader readPublicData];
}

-(void)readEIDPublicData
{
    //TODO
}

-(ReaderDeviceType)deviceTypeFromAccessory:(EAAccessory *)accessory
{
    if ([accessory.protocolStrings containsObject:@"com.keyxentic.kxpos01"]) {
        
        return ReaderDeviceTypeNefcom;
        
    }else if ([accessory.protocolStrings containsObject:@"com.precisebiometrics.ccidcontrol"]) {
        
        return ReaderDeviceTypeTactivo;
        
    }else if ([accessory.protocolStrings containsObject:@""]) {
        
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

-(void)dealloc
{
    [self stopListeningDeviceEvents];
    [self stopListeningCardEvents];
}

@end
