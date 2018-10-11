//
//  SFIWithRecordNumbers.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/18/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFIWithRecordNumbers : NSObject

@property (strong, nonatomic) NSNumber *sfi;
@property (assign, nonatomic) NSNumber *firstRecordNumber;
@property (assign, nonatomic) NSNumber *lastRecordNumber;

@end
