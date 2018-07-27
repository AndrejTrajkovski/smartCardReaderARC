//
//  EMVTlv.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/23/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "EMVTlv.h"

@implementation EMVTlv

-(instancetype)initWithBerTag:(BerTag *)berTag
                      andType:(TagValueType)type
                      andName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        
        self.tag = berTag;
        self.type = type;
        self.name = name;
    }
    
    return self;
}

@end
