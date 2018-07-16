//
//  GetResponseCAPDU.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/15/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "GetResponseCAPDU.h"

@implementation GetResponseCAPDU

-(instancetype)initWithExpectedLength:(Byte)le
{
    self = [super initWithCLA:0x00
                          INS:0xC0
                           p1:0x00
                           p2:0x00];
    
    if (self) {
        self.le = le;
        NSNumber *leNumber = [NSNumber numberWithUnsignedChar:le];
        self.bytes = [self.bytes arrayByAddingObject:leNumber];
    }
    
    return self;
}

@end
