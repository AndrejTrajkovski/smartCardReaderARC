#import "EIDFiles.h"

@implementation EIDFileOne
-(NSArray<NSNumber *> *)fileId
{
    return @[@0x02, @0x01];
}
-(NSArray<NSNumber *> *)baseTag
{
    return @[@0x70, @0x01];
}
@end

@implementation EIDFileTwo
-(NSArray<NSNumber *> *)fileId
{
    return @[@0x02, @0x02];
}
-(NSArray<NSNumber *> *)baseTag
{
    return @[@0x70, @0x02];
}
@end

@implementation EIDFileThree
-(NSArray<NSNumber *> *)fileId
{
    return @[@0x02, @0x03];
}
-(NSArray<NSNumber *> *)baseTag
{
    return @[@0x70, @0x03];
}
@end

@implementation EIDFileFour
-(NSArray<NSNumber *> *)fileId
{
    return @[@0x02, @0x05];
}
-(NSArray<NSNumber *> *)baseTag
{
    return @[@0x70, @0x05];
}

@end

@implementation EIDFileFive
-(NSArray<NSNumber *> *)fileId
{
    return @[@0x0A, @0x02];
}
-(NSArray<NSNumber *> *)baseTag
{
    return @[@0x7A, @0x02];
}
@end

@implementation EIDFileSix
-(NSArray<NSNumber *> *)fileId
{
    return @[@0x02, @0x07];
}
-(NSArray<NSNumber *> *)baseTag
{
    return @[@0x70, @0x07];
}
@end
