//
//  NSData+ByteManipulation.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/18/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "NSData+ByteManipulation.h"
#import "NSArray+ByteManipulation.h"

@implementation NSData (ByteManipulation)

+(instancetype)byteDataFromArray:(NSArray *)bytes
{
    return [NSData dataWithBytes:[bytes cArrayFromBytes] length:bytes.count];
}

@end
