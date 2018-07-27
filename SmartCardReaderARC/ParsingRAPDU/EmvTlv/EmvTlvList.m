//
//  EmvTlvList.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/23/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "EmvTlvList.h"
#import "EMVTlv.h"
#import "BerTag.h"
#import "EMVBerTags.h"

@implementation EmvTlvList

+(EMVTlv *)CARDHOLDER_NAME
{
    return [[EMVTlv alloc] initWithBerTag:[EMVBerTags CARDHOLDER_NAME] andType:Binary andName:@"CARDHOLDER NAME"];
}

+(EMVTlv *)APPLICATION_EXPIRATION_DATE
{
    return [[EMVTlv alloc] initWithBerTag:[EMVBerTags APPLICATION_EXPIRATION_DATE] andType:Binary andName:@"APPLICATION EXPIRATION DATE"];
}

+(NSArray *)list
{
    return @[
             [EmvTlvList CARDHOLDER_NAME],
             [EmvTlvList APPLICATION_EXPIRATION_DATE]
             ];
}

@end
