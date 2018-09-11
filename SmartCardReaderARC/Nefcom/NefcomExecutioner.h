//
//  NefcomExecutioner.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 9/10/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardReaderCommandExecutioner.h"
#import "lbrReader.h"

@protocol CardReaderCommandExecutioner;
@interface NefcomExecutioner : NSObject <CardReaderCommandExecutioner>
@property (strong, nonatomic) lbrReader* reader;

@end
