//
//  EIDBerTags.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/1/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BerTag;

@interface EIDBerTags : NSObject

//each file starts with the BASE_TAG
+(BerTag *)BASE_TAG;
+(BerTag *)ID_NUMBER;
+(BerTag *)CARD_NUMBER;

@end
