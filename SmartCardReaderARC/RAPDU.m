//
//  RAPDU.m
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import "RAPDU.h"
#import "NSArray+NSNumbersFromUnsignedCharArray.h"

@implementation RAPDU

-(instancetype)initWithResponseBytes:(unsigned char *)responseBytes
                           andLength:(int)length
                           andStatus:(PBSmartcardStatus)status
{
    self = [super init];
    
    if (self) {
        
        self.status = status;
        self.bytes = [[NSArray alloc] initFromCArray:responseBytes withCount:length];
    }
    
    return self;
}

@end
