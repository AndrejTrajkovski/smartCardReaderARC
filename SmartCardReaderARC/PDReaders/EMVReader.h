#import <Foundation/Foundation.h>
#import "DeviceReader.h"
#import "PDReader.h"

@class CAPDU, RAPDU, PBSmartcard;

@interface EMVReader : NSObject <PDReader>

@end
