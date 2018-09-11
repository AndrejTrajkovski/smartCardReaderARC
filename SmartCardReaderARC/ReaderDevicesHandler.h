//
//  ReaderDevicesHandler.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 9/10/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CardReaderCommandExecutioner;
@protocol ReaderDevicesHandler <NSObject>

-(void)startReaderWithSuccessBlock:(void (^)(id<CardReaderCommandExecutioner>))executioner andFailureBlock:(void (^)(NSError *error))failure;

@end
