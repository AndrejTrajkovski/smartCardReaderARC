//
//  APDUParser.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/17/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFIWithRecordNumbers.h"

extern NSString * const RAPDUParsingErrorDomain;

typedef NS_ENUM(NSInteger, RAPDUParsingErrorCode) {
    RAPDUParsingErrorCodeNoSpecificTag = 1,
    RAPDUParsingErrorCodeUnexpectedSFIData = 2,
    RAPDUParsingErrorCodeUnexpectedAFLData = 3,
    RAPDUParsingErrorCodeSFIOutOfScope = 4,
    RAPDUParsingErrorCodeSFIInvalid = 5
};

@class RAPDU, CAPDU;
@interface EMVParser : NSObject

-(NSNumber *)sfiFromRAPDU:(RAPDU *)rapdu error:(NSError **)error;

-(NSArray *)aidFromRAPDU:(RAPDU *)rapdu error:(NSError **)error;

-(NSArray *)sfisWithRecordNumbersFromRAPDU:(RAPDU *)rapdu error:(NSError **)error;

-(NSString *)berTlvParseData:(NSData *)recordsData;

-(NSArray *)PDOLFromRAPDU:(RAPDU *)rapdu error:(NSError **)error;

@end
