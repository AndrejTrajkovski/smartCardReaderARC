//
//  EMVTlv.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/23/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "EMVTlv.h"
#import "BerTag.h"
#import "HexUtil.h"

@implementation EMVTlv

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

-(instancetype)initFromCSVArray:(NSArray *)csvArray
{
    self = [super init];
    
    if (self) {
        
        if (csvArray.count > 0) {
            NSString *tagString = csvArray[0];
            NSData *tagBytes = [HexUtil parse:tagString];
            uint8_t const *bytes = tagBytes.bytes;
            if (tagBytes.length == 1) {
                
                self.tag = [[BerTag alloc] init:bytes[0]];
                
            }else if (tagBytes.length == 2){
                
                self.tag = [[BerTag alloc] init:bytes[0] secondByte:bytes[1]];
                
            }else if (tagBytes.length == 3){
                
                self.tag = [[BerTag alloc] init:bytes[0] secondByte:bytes[1] thirdByte:bytes[2]];
                
            }else{
                
                self.tag = nil;
            }

        }
        
        if (csvArray.count > 1) {
            self.name = csvArray[1];
        }
        if (csvArray.count > 2) {
            self.details = csvArray[2];
        }
        if (csvArray.count > 3) {
            //source
        }
        
        if (csvArray.count > 4) {
            NSString *type = csvArray[4];
            //FIXME:
            if ([type containsString:@"ans"] || [type hasPrefix:@"a"]) {
                self.type = Text;
            }else if ([type containsString:@"n "]){
                self.type = Numeric;
            }else if ([type containsString:@"binary"]){
                self.type = Binary;
            }
        }
    }
    
    return self;
}

@end
