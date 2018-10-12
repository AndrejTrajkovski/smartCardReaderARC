//
//  EIDParser.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EIDBaseFile, EIDTlv;

@interface EIDParser : NSObject
-(NSArray *)datainFile:(EIDBaseFile *)file;
@end
