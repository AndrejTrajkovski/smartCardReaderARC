//
//  EMVCard.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 8/10/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "EMVCard.h"
#import "BerTlv.h"
#import "EmvTlvList.h"
#import "EMVTlv.h"
#import "BerTlvParser.h"
#import "HexUtil.h"

@implementation EMVCard

-(instancetype)initWithAFLRecords:(NSArray *)aflRecords
{
    self = [super init];
    
    if (self) {
        
        __block BerTlvParser * parser = [[BerTlvParser alloc] init];
        
        [aflRecords enumerateObjectsUsingBlock:^(NSData *aflRecord, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData * dataAfl         = [HexUtil parse:aflRecord.description];
            BerTlv * tlvAfl          = [parser parseConstructed:dataAfl];
            
            EMVTlv *cardholderNameEmvTlv = [EmvTlvList CARDHOLDER_NAME];
            BerTlv *cardholderNameBerTlv = [tlvAfl find:cardholderNameEmvTlv.tag];
            if (cardholderNameBerTlv) {
                self.holderName = cardholderNameBerTlv.textValue;
                *stop = YES;
            }
        }];
        
        [aflRecords enumerateObjectsUsingBlock:^(NSData *aflRecord, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData * dataAfl         = [HexUtil parse:aflRecord.description];
            BerTlv * tlvAfl          = [parser parseConstructed:dataAfl];

            EMVTlv *expirationDateEmvTlv = [EmvTlvList APPLICATION_EXPIRATION_DATE];
            BerTlv *expirationDateBerTlv = [tlvAfl find:expirationDateEmvTlv.tag];
            
            if (expirationDateBerTlv) {
                
                NSData *expirationDateData = expirationDateBerTlv.value;
                //YYMMDD
                uint8_t const *bytes = expirationDateData.bytes;
                NSMutableString *mutableString = [NSMutableString new];
                if (expirationDateData.length > 1) {
                    uint8_t yy = bytes[0];
                    uint8_t mm = bytes[1];
                    
                    [mutableString appendFormat:@"%02X", mm];
                    [mutableString appendString:@"/"];
                    [mutableString appendFormat:@"%02X", yy];
                }
                
                self.expirationDateString = [NSString stringWithString:mutableString];
                *stop = YES;
            }
        }];
    }
    
    return self;
}

@end
