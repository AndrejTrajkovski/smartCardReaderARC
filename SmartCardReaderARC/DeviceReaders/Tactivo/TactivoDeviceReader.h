//
//  TactivoExecutioner.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/18/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceReader.h"

@class PBSmartcard;
@protocol DeviceReader;
@interface TactivoDeviceReader : NSObject <DeviceReader>

@end

