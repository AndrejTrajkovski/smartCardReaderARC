//
//  APDUParser.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/17/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAPDUParser : NSObject

-(NSNumber *)sfiFromData:(NSData *)data;
-(NSArray *)aidFromData:(NSData *)data;

@end
