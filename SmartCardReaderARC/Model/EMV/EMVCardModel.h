#import <Foundation/Foundation.h>

@class BerTlv;
@interface EMVCardModel : NSObject

@property (strong, nonatomic) NSString *panNumber;
@property (strong, nonatomic) NSString *holderName;
@property (strong, nonatomic) NSString *expirationDateString;

-(instancetype)initWithAFLRecords:(NSArray *)aflRecords;

@end
