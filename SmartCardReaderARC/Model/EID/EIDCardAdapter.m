#import "EIDCardAdapter.h"
#import <UIKit/UIImage.h>
#import "EIDCardModel.h"
#import "EIDFiles.h"
#import "EIDParser.h"
#import "EIDBerTags.h"
#import "EIDTlv.h"
#import "EidTlvList.h"

@interface EIDCardAdapter()

@property (nonatomic, strong) EIDParser *parser;

@end

@implementation EIDCardAdapter

-(instancetype)initWithParser:(EIDParser *)parser
{
    self = [super init];
    
    if (self) {
        self.parser = parser;
    }
    
    return self;
}

-(EIDCardModel *)cardModelForFiles:(NSArray *)files
{
    __block EIDCardModel *card = [EIDCardModel new];
    [files enumerateObjectsUsingBlock:^(EIDBaseFile *file, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([file isKindOfClass:[EIDFileOne class]]) {
            EIDTlv *cardNumberInfo = [EidTlvList CARD_NUMBER];
            NSData *cardNumberData = [self.parser dataForTag:cardNumberInfo.tag inBytes:file.bytes];
            card.cardNumber = [self stringForData:cardNumberData];
            
            EIDTlv *cardIdInfo = [EidTlvList ID_NUMBER];
            NSData *cardIdData = [self.parser dataForTag:cardIdInfo.tag inBytes:file.bytes];
            card.cardId = [self stringForData:cardIdData];
        }else if ([file isKindOfClass:[EIDFileTwo class]]){
            
        }
        
    }];
    return card;
}

-(NSString *)stringForData:(NSData *)data
{
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    return value;
}

-(NSNumber *)numberForData:(NSData *)data
{
    NSInteger decodedInteger;
    [data getBytes:&decodedInteger length:sizeof(decodedInteger)];
    NSNumber *integerObject = [NSNumber numberWithInteger:decodedInteger];
    return integerObject;
}

-(UIImage *)imageForData:(NSData *)data
{
    UIImage *myImage = [[UIImage alloc] initWithData:data];
    return myImage;
}

@end
