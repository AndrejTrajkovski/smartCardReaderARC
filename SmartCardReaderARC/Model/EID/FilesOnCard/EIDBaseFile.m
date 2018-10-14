#import "EIDBaseFile.h"

@implementation EIDBaseFile

-(NSArray<NSNumber *> *)fileId
{
    [NSException raise:NSInternalInconsistencyException
                format:@"Method fileId should be overridden in subclasses."];
    return nil;
}

@end
