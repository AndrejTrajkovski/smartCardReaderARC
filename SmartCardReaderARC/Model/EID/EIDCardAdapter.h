#import <Foundation/Foundation.h>
@class EIDCardModel;
@class EIDBaseFile;
@class EIDParser;

@interface EIDCardAdapter : NSObject

-(instancetype)initWithParser:(EIDParser *)parser;
-(EIDCardModel *)cardModelForFiles:(NSArray <EIDBaseFile *>*)files;

@end
