//
//  CAPDUGenerator.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/17/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CAPDU;
@interface CAPDUGenerator : NSObject

#pragma mark - EMV

+(CAPDU *)selectPSEDirectory;

+(CAPDU *)selectPPSEDirectory;

+(CAPDU *)getResponseWithLength:(NSNumber *)le;

+(CAPDU *)capduWithCAPDU:(CAPDU *)capdu withFixedLength:(NSNumber *)le;

+(CAPDU *)selectApplicationWithAID:(NSArray *)aid;

+(CAPDU *)getProcessingOptionsWithPDOL:(NSArray *)PDOL;

+(CAPDU *)readRecordWithRecordNumber:(NSNumber *)recordNumber SFI:(NSNumber *)sfi andLe:(NSNumber *)le;

#pragma mark - EID

+(CAPDU *)selectEmiratesCardFileWithFID:(NSArray *)fid;

+(CAPDU *)readEmiratesCardFileWithFID:(NSArray *)fid;

@end
