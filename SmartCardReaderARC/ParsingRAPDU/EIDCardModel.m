//
//  EIDCardModel.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/1/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "EIDCardModel.h"
#import "BerTlvParser.h"
#import "HexUtil.h"
#import "EidTlvList.h"
#import "EIDBerTags.h"
#import "BerTlv.h"

@implementation EIDCardModel

-(NSString *)cardId
{
    if (!_cardId) {
        
        __block BerTlvParser * parser = [[BerTlvParser alloc] init];
        
        NSData * dataAfl         = [HexUtil parse:self.file1.description];
        BerTlv * tlvAfl          = [parser parseConstructed:dataAfl];
        
        EIDTlv *cardNumberEidTlv = [EidTlvList ID_NUMBER];
        BerTlv *cardNumberBerTlv = [tlvAfl find:cardNumberEidTlv.tag];
        _cardId = cardNumberBerTlv.textValue;
        
        NSLog(@"cn : %@", _cardId);
    }
    
    return _cardId;
}

-(NSString *)cardNumber
{
    if (!_cardNumber) {
        
        BerTlvParser * parser = [[BerTlvParser alloc] init];
        
        NSData * dataAfl         = [HexUtil parse:self.file1.description];
        BerTlv * tlvAfl          = [parser parseConstructed:dataAfl];
        
        EIDTlv *cardNumberEidTlv = [EidTlvList CARD_NUMBER];
        BerTlv *cardNumberBerTlv = [tlvAfl find:cardNumberEidTlv.tag];
        _cardNumber = cardNumberBerTlv.textValue;
        NSLog(@"cn : %@", _cardNumber);
        
        
        
//        NSData * dataAfl         = [HexUtil parse:aflRecord.description];
//        BerTlv * tlvAfl          = [parser parseConstructed:dataAfl];
//
//        EMVTlv *cardholderNameEmvTlv = [EmvTlvList CARDHOLDER_NAME];
//        BerTlv *cardholderNameBerTlv = [tlvAfl find:cardholderNameEmvTlv.tag];

    }
    
    return _cardNumber;
}

@end
