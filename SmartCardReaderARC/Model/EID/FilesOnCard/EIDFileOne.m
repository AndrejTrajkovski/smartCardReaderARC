//
//  EIDFileOne.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "EIDFileOne.h"
#import "EIDBerTags.h"
#import "EidTlvList.h"

@implementation EIDFileOne

-(NSArray *)tags{
    NSArray *baseTags = [super tags];
    EIDTlv *cardNumberEidTlv = [self cardNumberEidTlv];
    NSArray *myTags = @[cardNumberEidTlv.tag];
    return [baseTags arrayByAddingObjectsFromArray:myTags];
}

- (EIDTlv *)cardNumberEidTlv{
    return [EidTlvList ID_NUMBER];
}

@end
