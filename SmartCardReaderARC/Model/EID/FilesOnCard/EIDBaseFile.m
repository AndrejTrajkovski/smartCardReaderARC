#import "EIDBaseFile.h"

@implementation EIDBaseFile

-(NSArray<NSNumber *> *)fileId
{
    [NSException raise:NSInternalInconsistencyException
                format:@"Method fileId should be overridden in subclasses."];
    return nil;
}

-(NSArray<NSNumber *> *)baseTag
{
    [NSException raise:NSInternalInconsistencyException
                format:@"Method baseTag should be overridden in subclasses."];
    return nil;
}

-(NSString *)bytesAsHex
{
    NSMutableString *bytesAsHexStr = [NSMutableString new];
    [_bytes enumerateObjectsUsingBlock:^(NSNumber *byte, NSUInteger idx, BOOL * _Nonnull stop) {
        [bytesAsHexStr appendFormat:@"%02X", byte.unsignedIntValue];
        [bytesAsHexStr appendString:@", "];
    }];
    return bytesAsHexStr;
}

@end
