//
//  BerTlv+Emv.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/27/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "BerTlv+Emv.h"
#import "BerTag.h"
#import "EmvTlvList.h"
#import "EMVTlv.h"

@implementation BerTlv (Emv)

- (NSString *)emvDump:(NSString *)aPadding {
    NSMutableString *sb = [[NSMutableString alloc] init];
    
    NSError *error = nil;
    EMVTlv *myEmv = [EmvTlvList emvTlvWithTag:self.tag error:&error];
    
    NSString *valueString;
    NSString *tagName;

    if (!myEmv) {
        valueString = error.localizedDescription;
        tagName = self.tag.hex;
    }else {
        valueString = self.textValue;
        tagName = myEmv.name;
    }
    
    if(self.primitive) {
        [sb appendFormat:@"%@ - [%@] %@\n", aPadding, tagName, valueString];
    } else {
        [sb appendFormat:@"%@ + [%@]\n", aPadding, tagName];
        NSMutableString *childPadding = [[NSMutableString alloc] init];
        [childPadding appendString:aPadding];
        [childPadding appendString:aPadding];
        for (BerTlv *tlv in self.list) {
            [sb appendString:[tlv emvDump:childPadding]];
        }
    }
    return sb;
}

@end
