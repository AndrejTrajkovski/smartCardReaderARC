#import <Foundation/Foundation.h>

@class EIDBaseFile, BerTag;
@interface EIDParser : NSObject
-(NSData *)dataForTag:(BerTag *)tag inFile:(EIDBaseFile *)file;
@end
