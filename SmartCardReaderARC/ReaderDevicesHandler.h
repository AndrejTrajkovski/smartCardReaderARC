//
//  ReaderDevicesHandler.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 9/10/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardReaderCommandExecutioner.h"

@protocol ReaderDevicesHandler <NSObject>

-(void)startDeviceWithSuccessBlock:(void (^)(id<CardReaderCommandExecutioner>))executioner andFailureBlock:(void (^)(NSError *error))failure;

@end
