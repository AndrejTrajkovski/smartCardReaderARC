//
//  RAPDU.m
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import "RAPDU.h"
#import "NSArray+ByteManipulation.h"

@implementation RAPDU{
    
    NSArray *response;
}

-(instancetype)initWithResponseBytes:(unsigned char *)responseBytes
                           andLength:(int)length
                           andStatus:(PBSmartcardStatus)status
{
    self = [super init];
    
    if (self) {
        
        self.status = status;
        response = [NSArray arrayWithUnsignedCharArray:responseBytes withCount:length];
    }
    
    return self;
}

-(NSArray *)bytes
{
    return response;
}

@end
