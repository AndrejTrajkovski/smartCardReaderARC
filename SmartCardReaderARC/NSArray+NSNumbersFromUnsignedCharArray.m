//
//  NSArray+NSNumbersFromUnsignedCharArray.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/15/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "NSArray+NSNumbersFromUnsignedCharArray.h"

@implementation NSArray (NSNumbersFromUnsignedCharArray)

-(instancetype)initFromCArray:(unsigned char *)unsignedCharArray withCount:(int)arrayCount
{
    self = [self init];
    
    if (self) {
        
        NSMutableArray *helperArray = [NSMutableArray new];
        for (int i = 0; i < arrayCount; i++) {
            unsigned char x = unsignedCharArray[i];
            NSNumber *number = [NSNumber numberWithUnsignedChar:x];
            [helperArray addObject:number];
        }
        self = [NSArray arrayWithArray:helperArray];
    }
    
    return self;
}

-(unsigned char *)cArrayFromBytes
{
    int myCount = (int)self.count;
    unsigned char *cArray = (unsigned char *)calloc(myCount, sizeof(unsigned char));
    for (int i=0; i < myCount; i++){
        cArray[i] = [[self objectAtIndex:i] unsignedCharValue];
    }
    return cArray;
}

@end
