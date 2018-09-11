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

extern NSString * const ReadingPublicDataErrorDomain;

typedef NS_ENUM(NSInteger, ReadingPublicDataErrorCode) {
    ReadingPublicDataErrorCodeWhenPreparingCard = 1,
    ReadingPublicDataErrorCodePDOLRequired = 2,
    ReadingPublicDataErrorCodeNoPSEDir = 3,
    ReadingPublicDataErrorCodeNoPPSEDir = 4,
    ReadingPublicDataErrorCodeSelectAID
    
};

@interface EMVReader : NSObject <PDReader>

@end
