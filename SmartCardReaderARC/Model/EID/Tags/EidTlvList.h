//
//  EidTlvList.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/1/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EIDTlv.h"

@interface EidTlvList : NSObject

+(EIDTlv *)ID_NUMBER;
+(EIDTlv *)CARD_NUMBER;

@end
