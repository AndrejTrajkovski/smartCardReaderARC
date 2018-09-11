//
//  NefcomExecutioner.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 9/10/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceReader.h"

@protocol DeviceReader;
@interface NefcomDeviceReader : NSObject <DeviceReader>

@end
