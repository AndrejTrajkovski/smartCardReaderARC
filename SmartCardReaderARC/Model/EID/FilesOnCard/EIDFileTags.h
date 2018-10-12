//
//  EIDFIle.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BerTag;
@protocol EIDFileTags <NSObject>
-(NSArray*)tags;
@end
