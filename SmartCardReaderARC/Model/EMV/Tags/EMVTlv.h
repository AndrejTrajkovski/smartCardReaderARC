#import <Foundation/Foundation.h>
@class BerTag;
typedef enum TagValueType : NSUInteger {
    Binary,
    Numeric,
    Text,
    Mixed,
    DOL,
    Template
} TagValueType;

@interface EMVTlv : NSObject

@property (assign, nonatomic) TagValueType type;
@property (strong, nonatomic) BerTag *tag;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *details;
@property (assign, nonatomic) NSUInteger minLength;
@property (assign, nonatomic) NSUInteger maxLength;

-(instancetype)initWithBerTag:(BerTag *)berTag
                      andName:(NSString *)name;

-(instancetype)initFromCSVArray:(NSArray *)csvArray;

@end
