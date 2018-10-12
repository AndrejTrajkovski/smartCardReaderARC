#import "EIDBaseFile.h"
#import "BerTag.h"
#import "EIDBerTags.h"

@implementation EIDBaseFile

-(instancetype)initWithBytes:(NSArray *)bytes
{
    self = [super init];
    
    if (self) {
        self.bytes = bytes;
    }
    
    return self;
}

-(BerTag *)baseTag
{
    return [EIDBerTags BASE_TAG];
}

@end
