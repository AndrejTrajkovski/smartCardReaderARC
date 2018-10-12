#import <Foundation/Foundation.h>

@interface CardAID : NSObject

@property (strong, nonatomic) NSArray *aid;
@property (strong, nonatomic) NSString *vendor;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSString *type;

-(instancetype)initFromCSVArray:(NSArray *)csvArray;
-(instancetype)initFromArray:(NSArray *)array;

@end
