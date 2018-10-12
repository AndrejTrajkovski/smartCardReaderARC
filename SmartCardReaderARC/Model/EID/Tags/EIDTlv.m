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
                 andValueType:(ValueType)valueType
{
    self = [super init];
    
    if (self) {
        
        self.tag = berTag;
        self.name = name;
        self.valueType = valueType;
    }
    
    return self;
}

@end
