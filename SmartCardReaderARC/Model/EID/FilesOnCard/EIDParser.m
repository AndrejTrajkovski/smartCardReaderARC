//
//  EIDParser.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "EIDParser.h"
#import "EIDBaseFile.h"
#import "NSArray+ByteManipulation.h"
#import "BerTag.h"
#import "NSArray+Util.h"
#import "NSData+ByteManipulation.h"

@implementation EIDParser

-(NSData *)datainFile:(EIDBaseFile *)file
{
    NSArray *fileTags = [file tags];
    
    for (int m = 0; m < fileTags.count; m++){
        BerTag *tag = fileTags[m];
        NSArray *tagBytes = [NSArray byteArrayFromData:tag.data];
        NSInteger indexOfTag = [file.bytes indexOfSubarray:tagBytes];
        if (indexOfTag == -1) {
            //tag not found
        }else{
            //cut 0x00 byte after tag
            //FIXME length > 1 byte
            NSInteger lengthOfTag = tagBytes.count;
            NSRange rangeOfTagByte = NSMakeRange(indexOfTag, lengthOfTag - indexOfTag);
            NSInteger extraZeroByteIndex = rangeOfTagByte.location + rangeOfTagByte.length;
            //FIXME: should cut file.bytes array and go from there
            if (file.bytes.count > extraZeroByteIndex) {
                NSNumber *extraByte = [file.bytes objectAtIndex:extraZeroByteIndex];
                if (![extraByte isEqualToNumber:@0x00]) {
                    //error, should be 0x00
                }else {
                    NSInteger lengthIndex = extraZeroByteIndex + 1;
                    if (file.bytes.count > lengthIndex) {
                        NSNumber* length = file.bytes[lengthIndex];
                        NSRange valueRange = NSMakeRange(lengthIndex + 1, length.integerValue);
                        NSArray *value = [file.bytes subarrayWithRange:valueRange];
                        NSData *dataInFile = [NSData byteDataFromArray:value];
                        return dataInFile;
                    }
                }
            }else {
                //no bytes after tag, I guess tag has no value
            }
        }

    }
    
    return nil;
}

@end
