#import "EIDParser.h"
#import "EIDBaseFile.h"
#import "NSArray+ByteManipulation.h"
#import "BerTag.h"
#import "NSArray+Util.h"
#import "NSData+ByteManipulation.h"
#import <UIKit/UIImage.h>
#import "EIDBerTags.h"

@implementation EIDParser

-(NSData *)dataForTag:(BerTag *)tag
{
    return nil;
}

-(NSData *)dataForTag:(BerTag *)tag inBytes:(NSArray *)bytes
{
    NSArray *dataWithNoBaseTLV = [self cutBaseTagDataInBytes:bytes];
    NSArray *tagBytesArray = [NSArray byteArrayFromData:tag.data];
    NSArray *valueAsArray = [self valueForTagBytes:tagBytesArray inBytes:dataWithNoBaseTLV];
    return [NSData byteDataFromArray:valueAsArray];
}

-(NSArray *)cutBaseTagDataInBytes:(NSArray *)bytes
{
    BerTag *baseTag = [EIDBerTags BASE_TAG];
    NSArray *tagBytesArray = [NSArray byteArrayFromData:baseTag.data];
    NSArray *noTagBytes = [self valueForTagBytes:tagBytesArray inBytes:bytes];
    return noTagBytes;
}

-(NSArray *)valueForTagBytes:(NSArray<BerTag *> *)tagBytes inBytes:(NSArray *)bytes
{
    NSArray *sliceStartingWithTag = [bytes sliceStartingWithSubarray:tagBytes];
    NSArray *sliceWithoutTAg = [self cutTag:tagBytes inBytes:sliceStartingWithTag];
    NSArray *sliceWithoutZeroByte = [self cutZeroByteInBytes:sliceWithoutTAg];
    NSNumber *lengthOfValue = [self lengthOfValueFromBytes:sliceWithoutZeroByte];
    NSArray *sliceWithoutLengthByte = [self cutLengthByteInBytes:sliceWithoutZeroByte];
    if (sliceWithoutLengthByte.count >= lengthOfValue.integerValue) {
        NSRange rangeOfValueSlice = NSMakeRange(0, lengthOfValue.integerValue);
        NSArray *valueSlice = [sliceWithoutLengthByte subarrayWithRange:rangeOfValueSlice];
        return valueSlice;
    }else {
        //error, probably bad data
        return sliceWithoutLengthByte;
    }
}

-(NSArray *)cutLengthByteInBytes:(NSArray *)bytes
{
    if (bytes.count > 0) {
        NSMutableArray *newBytes = [bytes mutableCopy];
        [newBytes removeObjectAtIndex:0];
        return [NSArray arrayWithArray:newBytes];
    }
    return nil;
}

-(NSNumber *)lengthOfValueFromBytes:(NSArray *)bytes
{
    if (bytes.count > 0) {
        return bytes.firstObject;
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
    //error, should have bytes after tag
    return bytes;
}

-(NSArray *)cutZeroByteInBytes:(NSArray *)bytes
{
    if (bytes.count > 0) {
        NSNumber *extraByte = [bytes objectAtIndex:0];
        if ([extraByte isEqual:@0x00]) {
            NSMutableArray *newBytes = [bytes mutableCopy];
            [newBytes removeObjectAtIndex:0];
            return [NSArray arrayWithArray:newBytes];
        }else {
            //error, should have 0x00 byte
            return bytes;
        }
    }
    //error, should have 0x00 byte
    return bytes;
}

@end
