#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface EIDCardModel : NSObject

@property (strong, nonatomic) NSString *cardId;
@property (strong, nonatomic) NSString *cardNumber; 
@property (strong, nonatomic) NSString *idType;
@property (strong, nonatomic) UIImage *facialImage;
@end
