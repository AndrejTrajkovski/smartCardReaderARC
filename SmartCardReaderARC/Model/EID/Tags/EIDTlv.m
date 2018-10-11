//
//  EIDTlv.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/1/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "EIDTlv.h"

@implementation EIDTlv

-(instancetype)initWithBerTag:(BerTag *)berTag
                      andName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        
        self.tag = berTag;
        self.name = name;
    }
    
    return self;
}

@end
