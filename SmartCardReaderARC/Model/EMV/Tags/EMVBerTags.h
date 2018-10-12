#import <Foundation/Foundation.h>

@class BerTag;
@interface EMVBerTags : NSObject

+(BerTag *)CARDHOLDER_NAME;
+(BerTag *)APPLICATION_EXPIRATION_DATE;
+(BerTag *)PAN_NUMBER;

@end
