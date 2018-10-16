#import "EIDCardModel.h"
#import <objc/runtime.h>

@implementation EIDCardModel

-(NSArray *)cardDesription
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([self class], &propertyCount);
    NSMutableArray * propertyNames = [NSMutableArray new];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue != nil) {
                NSLog(@"key: %@", propertyName);
                NSLog(@"value: %@", propertyValue);
                [propertyNames addObject:propertyName];
                [propertyNames addObject:@" : "];
                [propertyNames addObject:propertyValue];
                [propertyNames addObject:@"\n"];
        }
    }
    return propertyNames;
}

@end
