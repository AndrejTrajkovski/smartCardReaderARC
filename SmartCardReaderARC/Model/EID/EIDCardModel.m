#import "EIDCardModel.h"
#import "BerTlvParser.h"
#import "HexUtil.h"
#import "EidTlvList.h"
#import "EIDBerTags.h"
#import "BerTlv.h"
#import "EIDParser.h"

@implementation EIDCardModel

-(instancetype)initWithFileOne:(EIDFileOne *)fileOne
{
    self = [super init];
    
    if (self) {
        EIDParser *parser = [EIDParser new];
        NSData *cardId = [parser dataForTag:fileOne.cardIdEidTlv.tag inFile:fileOne];
        self.cardId = [[NSString alloc] initWithData:cardId encoding:NSASCIIStringEncoding];
        NSData *cardNumber = [parser dataForTag:fileOne.cardNumberEidTlv.tag inFile:fileOne];
        self.cardNumber = [[NSString alloc] initWithData:cardNumber encoding:NSASCIIStringEncoding];
        
    }
    
    return self;
}

@end
