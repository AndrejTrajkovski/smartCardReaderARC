#import <Foundation/Foundation.h>

@protocol BaseAID
-(NSArray *)aid;
@property (strong, nonatomic) NSArray *filesList;
@end

@interface AID01 : NSObject <BaseAID>

-(NSArray *)aid;
@property (strong, nonatomic) NSArray *filesList;

@end

@interface AID09 : NSObject <BaseAID>

-(NSArray *)aid;
@property (strong, nonatomic) NSArray *filesList;

@end
