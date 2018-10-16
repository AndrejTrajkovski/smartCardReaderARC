#import "EIDParser.h"
#import "EIDBaseFile.h"
#import "NSArray+ByteManipulation.h"
#import "BerTag.h"
#import "NSArray+Util.h"
#import "NSData+ByteManipulation.h"
#import <UIKit/UIImage.h>
#import "EIDBerTags.h"

@implementation EIDParser

static NSInteger lengthOfBytesIndicatingLengthOfValue = 2;

-(NSData *)dataForTag:(BerTag *)tag inFile:(EIDBaseFile *)file
{
    NSArray *dataWithNoBaseTag = [self cutTag:file.baseTag inBytes:file.bytes];
    NSArray *tagBytesArray = [NSArray byteArrayFromData:tag.data];
    NSArray *valueAsArray = [self valueForTagBytes:tagBytesArray inBytes:dataWithNoBaseTag];
    return [NSData byteDataFromArray:valueAsArray];
}

-(NSArray *)valueForTagBytes:(NSArray<BerTag *> *)tagBytes inBytes:(NSArray *)bytes
{
    NSArray *sliceStartingWithTag = [bytes sliceStartingWithSubarray:tagBytes];
    NSArray *sliceWithoutTAg = [self cutTag:tagBytes inBytes:sliceStartingWithTag];
    NSInteger lengthOfValue = [self lengthOfValueFromBytes:sliceWithoutTAg];
    NSArray *sliceWithoutLengthByte = [self cutLengthBytesInBytes:sliceWithoutTAg];
    if (sliceWithoutLengthByte.count >= lengthOfValue) {
        NSRange rangeOfValueSlice = NSMakeRange(0, lengthOfValue);
        NSArray *valueSlice = [sliceWithoutLengthByte subarrayWithRange:rangeOfValueSlice];
        return valueSlice;
    }else {
        //error, probably bad data
        return sliceWithoutLengthByte;
    }
}

-(NSArray *)cutLengthBytesInBytes:(NSArray *)bytes
{
    if (bytes.count > lengthOfBytesIndicatingLengthOfValue) {
        NSMutableArray *newBytes = [bytes mutableCopy];
        NSRange firstElementsRange = NSMakeRange(0, lengthOfBytesIndicatingLengthOfValue);
        [newBytes removeObjectsInRange:firstElementsRange];
        return [NSArray arrayWithArray:newBytes];
    }
    return nil;
}

-(NSInteger)lengthOfValueFromBytes:(NSArray<NSNumber *> *)bytes
{
    NSArray *lengthBytes = [self lengthBytesFromBytes:bytes];
    __block NSInteger totalLength = 0;
    [lengthBytes.reverseObjectEnumerator.allObjects enumerateObjectsUsingBlock:^(NSNumber *digit, NSUInteger idx, BOOL * _Nonnull stop) {

        double floatDigit = digit.doubleValue;
        double floatIdx = (double)idx;
        int x = pow(16, floatIdx * lengthOfBytesIndicatingLengthOfValue) * floatDigit;
        NSLog(@"X : %d", x);
        totalLength = totalLength + x;
    }];
    return totalLength;
}

-(NSArray<NSNumber *>*)lengthBytesFromBytes:(NSArray *)bytes
{
    if (bytes.count > 0) {
        NSRange firstTwoElementsRange = NSMakeRange(0, lengthOfBytesIndicatingLengthOfValue);
        return [bytes subarrayWithRange:firstTwoElementsRange];
    }
    return nil;
}

-(NSArray *)cutTag:(NSArray *)tag inBytes:(NSArray *)bytes
{
    NSRange tagRange = NSMakeRange(0, tag.count);
    if (bytes.count > tag.count) {
        NSMutableArray *newBytes = [bytes mutableCopy];
        [newBytes removeObjectsInRange:tagRange];
        return [NSArray arrayWithArray:newBytes];
    }
    //error, expected bytes after tag
    return bytes;
}

@end
