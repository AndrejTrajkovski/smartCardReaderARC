#import <Foundation/Foundation.h>

@class EMVTlv, BerTag;
@interface EmvTlvList : NSObject

+(EMVTlv *)PAN_NUMBER;
+(EMVTlv *)CARDHOLDER_NAME;
+(EMVTlv *)APPLICATION_EXPIRATION_DATE;

+(NSArray *)list;
+(EMVTlv *)emvTlvWithTag:(BerTag *)berTag error:(NSError **)error;

@end
