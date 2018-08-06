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

-(NSNumber *)sfiFromRAPDU:(RAPDU *)rapdu error:(NSError **)error;

-(NSArray *)aidFromRAPDU:(RAPDU *)rapdu error:(NSError **)error;

-(NSArray *)sfisWithRecordNumbersFromRAPDU:(RAPDU *)rapdu error:(NSError **)error;

-(NSString *)berTlvParseData:(NSData *)recordsData;

@end
