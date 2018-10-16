#import "EIDFiles.h"

@implementation EIDFile0201
-(NSArray<NSNumber *> *)fileId
{
    return @[@0x02, @0x01];
}
-(NSArray<NSNumber *> *)baseTag
{
    return @[@0x70, @0x01];
}
@end

@implementation EIDFile0202
-(NSArray<NSNumber *> *)fileId
{
    return @[@0x02, @0x02];
}
-(NSArray<NSNumber *> *)baseTag
{
    return @[@0x70, @0x02];
}
@end

@implementation EIDFile0203
-(NSArray<NSNumber *> *)fileId
{
    return @[@0x02, @0x03];
}
-(NSArray<NSNumber *> *)baseTag
{
    return @[@0x70, @0x03];
}
@end

@implementation EIDFile0205
-(NSArray<NSNumber *> *)fileId
{
    return @[@0x02, @0x05];
}
-(NSArray<NSNumber *> *)baseTag
{
    return @[@0x70, @0x05];
}

@end

@implementation EIDFile0A02
-(NSArray<NSNumber *> *)fileId
{
    return @[@0x0A, @0x02];
}
-(NSArray<NSNumber *> *)baseTag
{
    return @[@0x7A, @0x02];
}
@end

@implementation EIDFile0207
-(NSArray<NSNumber *> *)fileId
{
    return @[@0x02, @0x07];
}
-(NSArray<NSNumber *> *)baseTag
{
    return @[@0x70, @0x07];
}
@end
