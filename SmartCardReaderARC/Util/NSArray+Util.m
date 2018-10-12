//
//  NSArray+Util.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "NSArray+Util.h"

@implementation NSArray (Util)

-(NSInteger)indexOfSubarray:(NSArray *)subarray{
    
    for (int i = 0; i < self.count; i++) {
        if (self.count - i >= subarray.count){
            NSRange sliceOfMeRange = NSMakeRange(i, subarray.count);
            NSArray *sliceOfMe = [self subarrayWithRange:sliceOfMeRange];
            if ([sliceOfMe isEqual:subarray]) {
                return i;
            }else {
                continue;
            }
        }else {
            return -1;
        }
    }
    return -1;
}

@end
