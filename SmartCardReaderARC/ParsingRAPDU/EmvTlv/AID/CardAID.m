//
//  EmvAID.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/27/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "CardAID.h"
#import "HexUtil.h"
#import "NSArray+ByteManipulation.h"

@implementation CardAID

-(instancetype)initFromArray:(NSArray *)array
{
    self = [super init];
    
    if (self) {
        
        self.aid = array;
    }
    
    return self;
}

-(instancetype)initFromCSVArray:(NSArray *)csvArray
{
    self = [super init];
    
    if (self) {
        
        if (csvArray.count > 0) {
            self.aid = [CardAID aidAsNSNumbersArrayFromString:csvArray[0]];
        }
        if (csvArray.count > 1) {
            self.vendor = csvArray[1];
        }
        if (csvArray.count > 2) {
            self.country = csvArray[2];
        }
        if (csvArray.count > 3) {
            self.name = csvArray[3];
        }
        if (csvArray.count > 4) {
            self.details = csvArray[4];
        }
    }
    
    return self;
}

+(NSArray *)aidAsNSNumbersArrayFromString:(NSString *)aidString
{
    NSMutableArray *helperArray = [NSMutableArray new];
    
    for (int i = 0; i < aidString.length; i += 2) {
        NSString *oneHexString = [aidString substringWithRange:NSMakeRange(i, 2)];
        NSData *oneHexData = [HexUtil parse:oneHexString];
        NSArray *byteArrayFromData = [NSArray byteArrayFromData:oneHexData];
        [helperArray addObject:byteArrayFromData.firstObject];
    }

    return [NSArray arrayWithArray:helperArray];
}

@end
