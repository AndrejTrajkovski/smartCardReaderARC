//
//  CommandProcessor.h
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import <Foundation/Foundation.h>
#import "DeviceReader.h"
#import "PDReader.h"

@class CAPDU, RAPDU, PBSmartcard;

@interface EMVReader : NSObject <PDReader>

@end
