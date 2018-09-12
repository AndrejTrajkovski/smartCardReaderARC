//
//  SmartEID.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 9/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    CardTypeNoCard = 0,
    CardTypeEMV,
    CardTypeEID,
    CardTypeUnsupported
    
} CardType;

typedef enum {
    
    ReaderDeviceTypeNotRecognized = 0,
    ReaderDeviceTypeTactivo,
    ReaderDeviceTypeFeitian,
    ReaderDeviceTypeNefcom
    
} ReaderDeviceType;

@protocol SmartEIDDelegate

-(void)didInsertCard;
-(void)didRemoveCard;

-(void)didConnectDeviceReader;
-(void)didDisonnectDeviceReader;

-(void)didReadPublicData:(id)publicData;
-(void)didFailReadPublicData:(NSError *)error;

@end

@interface SmartEID : NSObject

@property (weak, nonatomic) id <SmartEIDDelegate> delegate;

-(void)readEIDPublicData;
-(void)readEMVPublicData;
-(CardType)currentCardType;

- (instancetype)initWithDelegate:(id <SmartEIDDelegate>)delegate;

@end
