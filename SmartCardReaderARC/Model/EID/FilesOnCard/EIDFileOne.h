#import "EIDBaseFile.h"
@class EIDTlv;

@interface EIDFileOne : EIDBaseFile

- (EIDTlv *)cardNumberEidTlv;
- (EIDTlv *)cardIdEidTlv;

@end
