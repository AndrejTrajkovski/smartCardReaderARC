#import "EIDBerTags.h"
#import "BerTag.h"

@implementation EIDBerTags

+(BerTag *)ID_NUMBER
{
    return [[BerTag alloc] init:0xE1 secondByte:0x01];
}

+(BerTag *)CARD_NUMBER
{
    return [[BerTag alloc] init:0xE1 secondByte:0x02];
}

+(BerTag *)ID_TYPE
{
    return [[BerTag alloc] init:0xE3 secondByte:0x05];
}

+(BerTag *)FACIAL_IMAGE
{
    return [[BerTag alloc] init:0x62 secondByte:0x03];
}

@end
