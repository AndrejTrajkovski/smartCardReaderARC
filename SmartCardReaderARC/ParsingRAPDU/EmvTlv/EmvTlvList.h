//
//  EmvTlvList.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/23/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMVTlv;
@interface EmvTlvList : NSObject

+(EMVTlv *)CARDHOLDER_NAME;
+(EMVTlv *)APPLICATION_EXPIRATION_DATE;

+(NSArray *)list;

@end
