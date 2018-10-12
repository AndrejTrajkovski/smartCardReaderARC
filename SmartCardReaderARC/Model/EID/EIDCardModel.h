#import <Foundation/Foundation.h>
#import "EIDFileOne.h"

@class EIDBaseFile;
@interface EIDCardModel : NSObject

-(instancetype)initWithFileOne:(EIDFileOne *)fileOne;
@property (strong, nonatomic) NSString *cardId;
@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSData *file1; 

@end
