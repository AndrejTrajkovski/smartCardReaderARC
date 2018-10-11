//
//  EMVBerTags.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/23/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BerTag;
@interface EMVBerTags : NSObject

+(BerTag *)CARDHOLDER_NAME;
+(BerTag *)APPLICATION_EXPIRATION_DATE;
+(BerTag *)PAN_NUMBER;

@end
