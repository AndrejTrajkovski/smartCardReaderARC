#import <Foundation/Foundation.h>

@interface EIDBaseFile : NSObject

@property (strong, nonatomic) NSArray *bytes;
//Method fileId should be overridden in subclasses.
-(NSArray<NSNumber *> *)fileId;

@end
