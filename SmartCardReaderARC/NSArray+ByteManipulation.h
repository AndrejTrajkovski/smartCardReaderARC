//
//  NSArray+ByteManipulation.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/15/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ByteManipulation)

+(instancetype)byteArrayFromData:(NSData *)data;
+(instancetype)byteArrayFromString:(NSString *)string;
+(instancetype)arrayWithUnsignedCharArray:(unsigned char *)unsignedCharArray
                                withCount:(int)arrayCount;
-(unsigned char *)cArrayFromBytes;

@end
