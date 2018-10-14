#import <Foundation/Foundation.h>

@class EIDBaseFile, BerTag;
@interface EIDParser : NSObject
-(NSData *)dataForTag:(BerTag *)tag inBytes:(NSArray *)bytes;

@end
