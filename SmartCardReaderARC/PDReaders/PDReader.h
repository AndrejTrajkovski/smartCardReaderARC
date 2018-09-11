//
//  PDReader.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 9/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceReader.h"

@protocol PDReaderDelegate <NSObject>

-(void)didReadPublicData:(id)publicDataRecords;
-(void)didFailToReadPublicDataWithError:(NSError *)error;

@end

@protocol PDReader <NSObject>

@property (weak) id <PDReaderDelegate> delegate;
@property (strong, nonatomic) id <DeviceReader> deviceReader;

-(instancetype)initWithDeviceReader:(id<DeviceReader>)deviceReader
                        andDelegate:(id <PDReaderDelegate>)delegate;
-(void)readPublicData;

@end
