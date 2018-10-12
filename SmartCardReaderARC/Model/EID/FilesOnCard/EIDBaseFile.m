//
//  EIDBaseFile.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "EIDBaseFile.h"
#import "BerTag.h"

@implementation EIDBaseFile

- (NSArray *)tags {
    BerTag *baseTag = [[BerTag alloc] init:0x70 secondByte:0x01];
    return @[baseTag];
}

@end
