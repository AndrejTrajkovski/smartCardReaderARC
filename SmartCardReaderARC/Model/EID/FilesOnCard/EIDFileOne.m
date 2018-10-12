#import "EIDFileOne.h"
#import "EidTlvList.h"

@implementation EIDFileOne

- (EIDTlv *)cardNumberEidTlv{
    return [EidTlvList CARD_NUMBER];
}

- (EIDTlv *)cardIdEidTlv{
    return [EidTlvList ID_NUMBER];
}

@end
