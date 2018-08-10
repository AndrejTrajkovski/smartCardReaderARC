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
#import "CAPDU.h"
#import "RAPDU.h"
#import "NSArray+ByteManipulation.h"
#import "NSData+ByteManipulation.h"
#import "HexUtil.h"
#import "EmvTlvList.h"
#import "EMVTlv.h"
#import "BerTlv+Emv.h"

@interface RAPDUParser()

@property (strong, nonatomic) BerTlvParser *berTlvParser;

@end

@implementation RAPDUParser

NSString *const RAPDUParsingErrorDomain = @"RAPDUParsingErrorDomain";

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.berTlvParser = [BerTlvParser new];
    }
    
    return self;
}

-(NSArray *)PDOLFromRAPDU:(RAPDU *)rapdu error:(NSError **)error{
    
    BerTag *pdolTag = [[BerTag alloc] init:0x9f secondByte:0x38];
    NSData *pdolData = [self valueForTag:pdolTag fromRAPDU:rapdu andError:error];
    if (!pdolData) {
        return nil;
    }
    unsigned char *aidHexBytes = (unsigned char *)[pdolData bytes];
    
    return [NSArray arrayWithUnsignedCharArray:aidHexBytes withCount:(int)pdolData.length];
}

-(NSArray *)aidFromRAPDU:(RAPDU *)rapdu error:(NSError **)error
{
    BerTag *aidTag = [[BerTag alloc] init:0x4f];
    NSData *aidData = [self valueForTag:aidTag fromRAPDU:rapdu andError:error];
    if (!aidData) {
        return nil;
    }
    unsigned char *aidHexBytes = (unsigned char *)[aidData bytes];
    return [NSArray arrayWithUnsignedCharArray:aidHexBytes withCount:(int)aidData.length];
}

-(NSNumber *)sfiFromData:(NSData *)data error:(NSError **)error
{
    if (!data) {
        return nil;
    }
    NSString *sfiStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];;
    
    NSUInteger length = [sfiStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (length > 1) {
        //error, sfi should not be longer that 1 byte (even 5 bits)
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[NSString stringWithFormat:@"Sfi should not be longer that 1 byte (even 5 bits). SFI : %@", sfiStr] forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:RAPDUParsingErrorDomain code:RAPDUParsingErrorCodeSFIInvalid userInfo:details];
        }
        return nil;
    }
    const char *sfiUtf8Str = [sfiStr UTF8String];
    unsigned char *sfiIndicatorRawBytes = (unsigned char *)sfiUtf8Str;
    NSNumber *sfiIndicator = [NSNumber numberWithUnsignedChar:*sfiIndicatorRawBytes];
    
    return [self sfiWithShiftAndAddFourToByte:sfiIndicator error:error];
}

-(NSNumber *)sfiFromRAPDU:(RAPDU *)rapdu error:(NSError **)error
{
    BerTag *sfiTag = [[BerTag alloc] init:0x88];
    NSData *sfiData = [self valueForTag:sfiTag fromRAPDU:rapdu andError:error];
    
    return [self sfiFromData:sfiData error:error];
}

-(NSArray *)sfisWithRecordNumbersFromRAPDU:(RAPDU *)rapdu error:(NSError **)error
{
    NSArray *aflGroupsBytes;
    
    if ([rapdu.bytes.firstObject isEqualToNumber:@0x80]) {
        
        if (rapdu.bytes.count > 3) {
            
            NSUInteger numberOfBytesBeforeAFLGroups = 4;
            NSRange aflGroupsRange = NSMakeRange(numberOfBytesBeforeAFLGroups, rapdu.bytes.count - 2  - numberOfBytesBeforeAFLGroups);
            aflGroupsBytes = [rapdu.bytes subarrayWithRange:aflGroupsRange];
        }
        
    }else if ([rapdu.bytes.firstObject isEqualToNumber:@0x77]){
        
        Byte aflTag = 0x94;
        BerTag *aflBerTag = [[BerTag alloc] init:aflTag];
        NSData *data = [NSData byteDataFromArray:rapdu.bytes];
        BerTlv *tlv = [self.berTlvParser parseConstructed:data];
        BerTlv *aflTLV = [tlv find:aflBerTag];
        NSLog(@"afl hex : %@ \n", aflTLV.hexValue);
        
        if (!aflTLV.value) {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"No 0x94 tag in afl data." forKey:NSLocalizedDescriptionKey];
            if (error) {
                *error = [NSError errorWithDomain:RAPDUParsingErrorDomain code:RAPDUParsingErrorCodeUnexpectedAFLData userInfo:details];
            }
            return nil;
        }
        
        aflGroupsBytes = [NSArray byteArrayFromData:aflTLV.value];

    }else{
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"AFL records first byte is neither 0x77 nor 0x80." forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:RAPDUParsingErrorDomain code:RAPDUParsingErrorCodeUnexpectedAFLData userInfo:details];
        }
        return nil;
    }
    
    return [self sfisWithRecordNumbersFromAFLGroupsBytes:aflGroupsBytes error:error];
}

-(NSArray *)sfisWithRecordNumbersFromAFLGroupsBytes:(NSArray *)aflGroupsBytes error:(NSError **)error
{
    NSMutableArray *sfisWithRecordNumbers = [NSMutableArray new];

    //afl groups should be 4 bytes each
    int numberOfAflGroups = (int)aflGroupsBytes.count / 4;
    for (int aflGroupIndex = 0; aflGroupIndex < numberOfAflGroups * 4; aflGroupIndex += 4) {
        
        NSNumber *firstByteOfAflGroup = [aflGroupsBytes objectAtIndex:aflGroupIndex];
        NSNumber *secondByteOfAflGroup = [aflGroupsBytes objectAtIndex:aflGroupIndex + 1];
        NSNumber *thirdByteOfAflGroup = [aflGroupsBytes objectAtIndex:aflGroupIndex + 2];
        //offline data authentication byte
        //NSNumber *fourthByteOfAflGroup = [aflGroups objectAtIndex:i + 3];
        NSUInteger sfiIndicator = [firstByteOfAflGroup unsignedIntegerValue];
        NSUInteger removeLast3Bits = sfiIndicator >> 3;
        NSNumber *sfi = [self sfiWithShiftAndAddFourToByte:[NSNumber numberWithUnsignedInteger:removeLast3Bits] error:error];
        if (!sfi) {
            return nil;
        }
        SFIWithRecordNumbers *sfiWithRecords = [SFIWithRecordNumbers new];
        sfiWithRecords.sfi = sfi;
        sfiWithRecords.firstRecordNumber = secondByteOfAflGroup;
        sfiWithRecords.lastRecordNumber = thirdByteOfAflGroup;
        [sfisWithRecordNumbers addObject:sfiWithRecords];
    }
    
    if (sfisWithRecordNumbers.count == 0) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"AFL records data shorter than 4 bytes." forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:RAPDUParsingErrorDomain code:RAPDUParsingErrorCodeUnexpectedAFLData userInfo:details];
        }
        return nil;
    }
    
    return sfisWithRecordNumbers;
}

-(NSNumber *)sfiWithShiftAndAddFourToByte:(NSNumber *)byte error:(NSError **)error
{
    int sfiAsInt = [byte intValue];;
    if (sfiAsInt <= 10) {
        //ok
        sfiAsInt = sfiAsInt << 3;
        sfiAsInt = sfiAsInt | 4;
        
    }else if (sfiAsInt > 10 && sfiAsInt <= 20){
        //payment system specific
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[NSString stringWithFormat:@"SFI is payment system specific. SFI : %d", sfiAsInt] forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:RAPDUParsingErrorDomain code:RAPDUParsingErrorCodeSFIOutOfScope userInfo:details];
        }
        return nil;
    }else if (sfiAsInt > 20 && sfiAsInt <= 30){
        //issuer specific
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[NSString stringWithFormat:@"SFI is issuer specific. SFI : %d", sfiAsInt] forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:RAPDUParsingErrorDomain code:RAPDUParsingErrorCodeSFIOutOfScope userInfo:details];
        }
        return nil;
    }else{
        //error
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[NSString stringWithFormat:@"SFI is longer than 30 bits. SFI : %d", sfiAsInt] forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:RAPDUParsingErrorDomain code:RAPDUParsingErrorCodeSFIInvalid userInfo:details];
        }
        return nil;
    }
    
    return [NSNumber numberWithInt:sfiAsInt];
}

-(NSString *)berTlvParseData:(NSData *)recordsData
{
    NSData * data         = [HexUtil parse:recordsData.description];
    BerTlvParser * parser = [[BerTlvParser alloc] init];
    BerTlv * tlv          = [parser parseConstructed:data];
    return [tlv emvDump:@"  "];
}

-(NSData *)valueForTag:(BerTag *)tag fromRAPDU:(RAPDU *)rapdu andError:(NSError **)error
{
    if (!rapdu) {
        return nil;
    }
    
    if (!tag) {
        @throw [NSException exceptionWithName:@"No tag specified." reason:@"Must specify tag." userInfo:nil];
    }
    
    NSData *data = [NSData byteDataFromArray:rapdu.bytes];
    BerTlv *tlv = [self.berTlvParser parseConstructed:data];
    BerTlv *sfiTLV = [tlv find:tag];
    
    if (!sfiTLV) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[NSString stringWithFormat:@"No %@ tag present.", tag.hex] forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:RAPDUParsingErrorDomain code:1 userInfo:details];
        }
        return nil;
    }
    
    return sfiTLV.value;
}

@end
