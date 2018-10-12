//
//  EidTlvList.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/1/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "EidTlvList.h"
#import "EIDBerTags.h"

@implementation EidTlvList

+(EIDTlv *)ID_NUMBER
{
    return [[EIDTlv alloc] initWithBerTag:[EIDBerTags ID_NUMBER] andName:@"ID NUMBER" andValueType:ValueTypeText];
}

+(EIDTlv *)CARD_NUMBER
{
    return [[EIDTlv alloc] initWithBerTag:[EIDBerTags CARD_NUMBER] andName:@"CARD NUMBER" andValueType:ValueTypeText];
}

@end
