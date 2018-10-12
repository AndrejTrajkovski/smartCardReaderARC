#import <Foundation/Foundation.h>

@class BerTag;
@interface EIDBaseFile : NSObject

-(instancetype)initWithBytes:(NSArray *)bytes;
@property (strong, nonatomic) NSArray *bytes;
-(BerTag *)baseTag;

@end
