//
//  APDUParser.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/17/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFIWithRecordNumbers.h"

@class RAPDU, CAPDU;
@interface RAPDUParser : NSObject

-(NSNumber *)sfiFromRAPDU:(RAPDU *)rapdu;

-(NSArray *)aidFromRAPDU:(RAPDU *)rapdu;

-(NSArray *)sfisWithRecordNumbersFromRAPDU:(RAPDU *)rapdu;

-(NSString *)berTlvParseData:(NSData *)recordsData;

//-(NSString *)decodeEMVData:(NSData *)emvData;
-(NSString *)encodeEMVData:(NSData *)recordsData;

@end
