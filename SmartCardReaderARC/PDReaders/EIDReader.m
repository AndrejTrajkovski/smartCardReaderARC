//
//  EIDReader.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 9/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "EIDReader.h"

@implementation EIDReader

@synthesize delegate;

@synthesize deviceReader;

- (instancetype)initWithDeviceReader:(id<DeviceReader>)deviceReader andDelegate:(id<PDReaderDelegate>)delegate {
    
    //TODO
    return nil;
}

- (void)readPublicData {
    
    //TODO
}

@end
