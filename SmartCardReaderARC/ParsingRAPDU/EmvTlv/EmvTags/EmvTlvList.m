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
#import "CHCSVParser.h"
#import "EMVBerTags.h"

static NSArray *list = nil;

@implementation EmvTlvList

+(NSArray *)getEmvTagsListFromResourceFileError:(NSError **)error
{
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"EMVTagsList" withExtension:@"csv"];
    NSArray *csvArray = [NSArray arrayWithContentsOfCSVURL:path];
    
    if (csvArray && csvArray.count > 1) {
        //cut first row(column titles)
        csvArray = [csvArray subarrayWithRange:NSMakeRange(1, csvArray.count - 1)];
        
        NSMutableArray *helperList = [NSMutableArray new];
        for (NSUInteger i = 0; i < csvArray.count; i++) {
            EMVTlv *oneEmvTag = [[EMVTlv alloc] initFromCSVArray:csvArray[i]];
            [helperList addObject:oneEmvTag];
        }
        
        return helperList;
    }
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:@"No Emv Tags CSV list file" forKey:NSLocalizedDescriptionKey];
    *error = [NSError errorWithDomain:@"Error parsing emv tags."
                                 code:201
                             userInfo:details];
    
    return nil;
}

//+(NSArray *)list
//{
//    if (!list) {
//
//        list = [EmvTlvList getEmvTagsListFromResourceFileError:nil];
//    }
//
//    return list;
//}

+(EMVTlv *)PAN_NUMBER
{
    return [[EMVTlv alloc] initWithBerTag:[EMVBerTags PAN_NUMBER] andName:@"PAN NUMBER"];
}

+(EMVTlv *)CARDHOLDER_NAME
{
    return [[EMVTlv alloc] initWithBerTag:[EMVBerTags CARDHOLDER_NAME] andName:@"CARDHOLDER NAME"];
}

+(EMVTlv *)APPLICATION_EXPIRATION_DATE
{
    return [[EMVTlv alloc] initWithBerTag:[EMVBerTags APPLICATION_EXPIRATION_DATE] andName:@"APPLICATION EXPIRATION DATE"];
}

+(NSArray *)list
{
    return @[
             [EmvTlvList CARDHOLDER_NAME],
             [EmvTlvList APPLICATION_EXPIRATION_DATE],
             [EmvTlvList PAN_NUMBER]
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
