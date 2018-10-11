//
//  NSArray+ByteManipulation.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/15/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "NSArray+ByteManipulation.h"

@implementation NSArray (ByteManipulation)

+(instancetype)byteArrayFromData:(NSData *)data
{
    
    unsigned char *hexBytes = (unsigned char *)[data bytes];
    int length = (int)[data length];
    
    return [NSArray arrayWithUnsignedCharArray:hexBytes withCount:length];
}


+(instancetype)byteArrayFromString:(NSString *)string
{
    const char *utf8Str = [string UTF8String];
    Byte *rawBytes = (unsigned char *)utf8Str;
    int count = (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    return [NSArray arrayWithUnsignedCharArray:rawBytes withCount:count];
}

+(instancetype)arrayWithUnsignedCharArray:(unsigned char *)unsignedCharArray
                               withCount:(int)arrayCount
{
    NSMutableArray *helperArray = [NSMutableArray new];
    for (int i = 0; i < arrayCount; i++) {
        unsigned char x = unsignedCharArray[i];
        NSNumber *number = [NSNumber numberWithUnsignedChar:x];
        [helperArray addObject:number];
    }
    
    return [NSArray arrayWithArray:helperArray];;
}


//-(instancetype)initFromUnsignedCharArray:(unsigned char *)unsignedCharArray
//                               withCount:(int)arrayCount
//{
//    self = [self init];
//
//    if (self) {
//
//        NSMutableArray *helperArray = [NSMutableArray new];
//        for (int i = 0; i < arrayCount; i++) {
//            unsigned char x = unsignedCharArray[i];
//            NSNumber *number = [NSNumber numberWithUnsignedChar:x];
//            [helperArray addObject:number];
//        }
//        self = [NSArray arrayWithArray:helperArray];
//    }
//
//    return self;
//}

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