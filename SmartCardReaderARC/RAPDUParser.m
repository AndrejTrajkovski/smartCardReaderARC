//
//  APDUParser.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/17/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "RAPDUParser.h"
#import "BerTlvParser.h"
#import "BerTag.h"
#import "BerTlv.h"
#import "BerTlvs.h"
#import "NSArray+NSNumbersFromUnsignedCharArray.h"

@interface RAPDUParser()

@property (strong, nonatomic) BerTlvParser *berTlvParser;

@end

@implementation RAPDUParser

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.berTlvParser = [BerTlvParser new];
    }
    
    return self;
}

-(NSArray *)aidFromData:(NSData *)data
{
    Byte aidTag = 0x4F;
    BerTag *aidBerTag = [[BerTag alloc] init:aidTag];
    
    BerTlv *tlv = [self.berTlvParser parseConstructed:data];
    
    BerTlv *aidTLV = [tlv find:aidBerTag];
    NSData *aidAsData = aidTLV.value;
    unsigned char *aidHexBytes = (unsigned char *)[aidAsData bytes];
//    NSUInteger length = [aidAsData ];
    
    return [[NSArray alloc] initFromCArray:aidHexBytes withCount:(int)[aidAsData length]];
}

-(Byte)sfiFromData:(NSData *)data
{
    Byte sfiTag = 0x88;
    BerTag *sfiBerTag = [[BerTag alloc] init:sfiTag];
    
    BerTlv *tlv = [self.berTlvParser parseConstructed:data];
    
    BerTlv *sfiTLV = [tlv find:sfiBerTag];
    NSLog(@"sfi : %@", sfiTLV.hexValue);
    
    NSString *sfiStr = sfiTLV.textValue;
    
    NSUInteger length = [sfiStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (length > 1) {
        //error, sfi should not be longer that 1 byte (even 5 bits)
    }
    const char *sfiUtf8Str = [sfiStr UTF8String];
    unsigned char *sfiRawBytes = (unsigned char *)sfiUtf8Str;
    int sfiAsInt = [[NSNumber numberWithUnsignedChar:*sfiRawBytes] intValue];;
    if (sfiAsInt <= 10) {
        //ok
        sfiAsInt = sfiAsInt << 3;
        sfiAsInt = sfiAsInt | 4;
        
    }else if (sfiAsInt > 10 && sfiAsInt <= 20){
        //payment system specific
    }else if (sfiAsInt > 20 && sfiAsInt <= 30){
        //issuer specific
    }else{
        //error
    }
    Byte finalSFI = [[NSNumber numberWithInt:sfiAsInt] unsignedCharValue];
    return finalSFI;
}

@end
