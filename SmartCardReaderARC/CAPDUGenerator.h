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

+(CAPDU *)selectPSEDirectory;

+(CAPDU *)selectPPSEDirectory;

+(CAPDU *)getResponseWithLength:(Byte)le;

+(CAPDU *)selectApplicationWithAID:(Byte *)aid withLength:(Byte)commandLength;

+(CAPDU*)getProcessingOptionsWithPDOL:(Byte)PDOL;

+(CAPDU *)readRecordWithRecordNumber:(Byte)recordNumber andSFI:(Byte)sfi;

@end
