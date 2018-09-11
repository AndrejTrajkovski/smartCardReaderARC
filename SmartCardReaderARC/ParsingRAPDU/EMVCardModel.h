//
//  EMVCard.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 8/10/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BerTlv;
@interface EMVCardModel : NSObject

@property (strong, nonatomic) NSString *panNumber;
@property (strong, nonatomic) NSString *holderName;
@property (strong, nonatomic) NSString *expirationDateString;

-(instancetype)initWithAFLRecords:(NSArray *)aflRecords;

@end
