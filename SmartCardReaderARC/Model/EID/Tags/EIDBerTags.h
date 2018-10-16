#import <Foundation/Foundation.h>
@class BerTag;

@interface EIDBerTags : NSObject

+(BerTag *)ID_NUMBER;
+(BerTag *)CARD_NUMBER;
+(BerTag *)ID_TYPE;
+(BerTag *)FACIAL_IMAGE;

@end
