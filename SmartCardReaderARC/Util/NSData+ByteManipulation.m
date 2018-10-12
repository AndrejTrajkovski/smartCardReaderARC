#import "NSData+ByteManipulation.h"
#import "NSArray+ByteManipulation.h"

@implementation NSData (ByteManipulation)

+(instancetype)byteDataFromArray:(NSArray *)bytes
{
    return [NSData dataWithBytes:[bytes cArrayFromBytes] length:bytes.count];
}

@end
