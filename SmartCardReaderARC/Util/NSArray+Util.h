//
//  NSArray+Util.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Util)
//-1 if not found
-(NSInteger)indexOfSubarray:(NSArray *)subarray;

@end
