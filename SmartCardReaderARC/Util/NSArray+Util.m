#import "NSArray+Util.h"

@implementation NSArray (Util)

-(NSArray *)sliceStartingWithSubarray:(NSArray *)subarray
{
    NSRange range = [self rangeOfSliceStartingWithSubarray:subarray];
    if (range.location != NSNotFound && range.length != NSNotFound) {
        return [self subarrayWithRange:range];
    }
    return nil;
}

-(NSRange)rangeOfSliceStartingWithSubarray:(NSArray *)subarray
{
    NSInteger indexOfSubarray = [self indexOfSubarray:subarray];
    NSInteger lengthOfSubarray = [self lengthOfSliceStartingWithSubarray:subarray];
    
    return NSMakeRange(indexOfSubarray, lengthOfSubarray);
}

-(NSInteger)lengthOfSliceStartingWithSubarray:(NSArray *)subarray
{
    NSInteger startingIndexOfSubarray = [self indexOfSubarray:subarray];
    if (startingIndexOfSubarray != NSNotFound) {
        NSInteger numberOfBytesCut = startingIndexOfSubarray;
        NSInteger length = self.count - numberOfBytesCut;
        if (self.count >= length) {
            return length;
        }else {
            return NSNotFound;
        }
    }
    return NSNotFound;
}

-(NSInteger)indexOfSubarray:(NSArray *)subarray
{
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
            return NSNotFound;
        }
    }
    return NSNotFound;
}

@end
