#import <Foundation/Foundation.h>

@interface NSArray (ByteManipulation)

+(instancetype)byteArrayFromData:(NSData *)data;
+(instancetype)byteArrayFromString:(NSString *)string;
+(instancetype)arrayWithUnsignedCharArray:(unsigned char *)unsignedCharArray
                                withCount:(int)arrayCount;
-(unsigned char *)cArrayFromBytes;

@end
