#import "EMVBerTags.h"
#import "BerTag.h"

@implementation EMVBerTags

+(BerTag *)PAN_NUMBER
{
    return [[BerTag alloc] init:0x5a];
}

+(BerTag *)CARDHOLDER_NAME
{
    return [[BerTag alloc] init:0x5f secondByte:0x20];
}

+(BerTag *)APPLICATION_EXPIRATION_DATE
{
    return [[BerTag alloc] init:0x5f secondByte:0x24];
}

@end
