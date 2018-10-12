//
//  EIDBerTags.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/1/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "EIDBerTags.h"
#import "BerTag.h"

@implementation EIDBerTags

+(BerTag *)BASE_TAG
{
    return [[BerTag alloc] init:0x70 secondByte:0x01];
}

+(BerTag *)ID_NUMBER
{
    return [[BerTag alloc] init:0xE1 secondByte:0x01];
}

+(BerTag *)CARD_NUMBER
{
    return [[BerTag alloc] init:0xE1 secondByte:0x02];
}

@end
