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
@property (assign, nonatomic) DeviceType connectedDevice;

@end

@implementation SmartEID

#pragma mark - PDReaderDelegate

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
    [self recognizeConnectedDeviceReader];
    self.reader = [[EMVReader alloc] initWithDeviceReader:[self readerForConnectedDevice]
                                              andDelegate:self];
    [self.reader readPublicData];
}

-(void)readEIDPublicData
{
    //TODO
}

-(void)recognizeConnectedDeviceReader
{
    [[[EAAccessoryManager sharedAccessoryManager] connectedAccessories] enumerateObjectsUsingBlock:^(EAAccessory * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.protocolStrings containsObject:@"com.keyxentic.kxpos01"]) {
            
            self.connectedDevice = DeviceTypeNefcom;
            
        }else if ([obj.protocolStrings containsObject:@"com.precisebiometrics.ccidcontrol"]) {
            
            self.connectedDevice = DeviceTypeTactivo;
            
        }else if ([obj.protocolStrings containsObject:@""]) {
            
            self.connectedDevice = DeviceTypeFeitian;
        }
    }];
}

-(id<DeviceReader>)readerForConnectedDevice
{
    switch (self.connectedDevice) {
            case DeviceTypeNoDevice:
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
@end
