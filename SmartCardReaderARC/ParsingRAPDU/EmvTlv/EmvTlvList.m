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

+(EMVTlv *)emvTlvWithTag:(BerTag *)berTag error:(NSError **)error
{
    __block EMVTlv *emvTlv = nil;
    [[self list] enumerateObjectsUsingBlock:^(EMVTlv* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([berTag isEqualToTag:obj.tag]) {
            emvTlv = obj;
        }
    }];
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:[NSString stringWithFormat:@"Could not find emv tag %@", berTag.hex] forKey:NSLocalizedDescriptionKey];
    *error = [NSError errorWithDomain:@"Error parsing emv tags."
                                 code:200
                             userInfo:details];
    return emvTlv;
}
@end
