//
//  APDU.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/19/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APDU <NSObject>

-(NSArray *)bytes;

@end
