#import <Foundation/Foundation.h>
#import "EIDTlv.h"

@interface EidTlvList : NSObject

+(EIDTlv *)ID_NUMBER;
+(EIDTlv *)CARD_NUMBER;

@end
