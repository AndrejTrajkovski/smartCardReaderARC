//
//  SmartEID.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 9/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "SmartEID.h"

#import <ExternalAccessory/ExternalAccessory.h>

#import "EMVReader.h"
#import "EIDReader.h"

#import "TactivoDeviceReader.h"
#import "NefcomDeviceReader.h"
#import "FeitianDeviceReader.h"

@interface SmartEID() <PDReaderDelegate>

@property (strong, nonatomic) id<PDReader> reader;

@end

@implementation SmartEID

- (instancetype)initWithDelegate:(id <SmartEIDDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self startListeningPortEvents];
    }
    return self;
}

#pragma mark - PDReaderDelegate

-(void)startListeningPortEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessoryDidConnect:)
                                                 name:EAAccessoryDidConnectNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessoryDidDisconnect:)
                                                 name:EAAccessoryDidDisconnectNotification
                                               object:nil];
}

-(void)stopListeningPortEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EAAccessoryDidConnectNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EAAccessoryDidDisconnectNotification
                                                  object:nil];
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

-(CardType)currentCardType
{
    //TODO
    return CardTypeNoCard;
}

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

#pragma mark - Implementation

-(void)readEMVPublicData
{
    NSPredicate *recognizedReaderPredicate = [NSPredicate predicateWithBlock:^BOOL(EAAccessory *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [self deviceTypeFromAccessory:evaluatedObject] != DeviceTypeNotRecognized;
    }];
    EAAccessory *recognizedAccessory = [[[[EAAccessoryManager sharedAccessoryManager] connectedAccessories] filteredArrayUsingPredicate:recognizedReaderPredicate] firstObject];
    
    [self readEMVPublicDataFromAccessory:recognizedAccessory];
}

-(void)readEMVPublicDataFromAccessory:(EAAccessory *)accessory
{
    DeviceType typeOfConnectedDevice = [self deviceTypeFromAccessory:accessory];
    [self readEMVPublicDataForDeviceType:typeOfConnectedDevice];
}

-(void)readEMVPublicDataForDeviceType:(DeviceType)deviceType
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

-(DeviceType)deviceTypeFromAccessory:(EAAccessory *)accessory
{
    if ([accessory.protocolStrings containsObject:@"com.keyxentic.kxpos01"]) {
        
        return DeviceTypeNefcom;
        
    }else if ([accessory.protocolStrings containsObject:@"com.precisebiometrics.ccidcontrol"]) {
        
        return DeviceTypeTactivo;
        
    }else if ([accessory.protocolStrings containsObject:@""]) {
        
        return DeviceTypeFeitian;
    }else{
        
        return DeviceTypeNotRecognized;
    }
}

-(id<DeviceReader>)readerForDeviceType:(DeviceType)deviceType
{
    switch (deviceType) {
            case DeviceTypeNotRecognized:
            return nil;
        case DeviceTypeNefcom:
            return [NefcomDeviceReader new];
            break;
        case DeviceTypeTactivo:
            return [TactivoDeviceReader new];
            break;
        case DeviceTypeFeitian:
            return [FeitianDeviceReader new];
            break;
    }
}

-(void)dealloc
{
    [self stopListeningPortEvents];
}

@end
