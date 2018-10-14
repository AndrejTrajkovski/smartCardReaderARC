#import <Foundation/Foundation.h>
@class BerTag;

@interface EIDBerTags : NSObject

//each file starts with the BASE_TAG
+(BerTag *)BASE_TAG;
+(BerTag *)ID_NUMBER;
+(BerTag *)CARD_NUMBER;

@end
