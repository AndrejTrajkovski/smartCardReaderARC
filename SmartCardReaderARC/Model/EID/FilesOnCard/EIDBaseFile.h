//
//  EIDBaseFile.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EIDFileTags.h"

@interface EIDBaseFile : NSObject <EIDFileTags>

@property (strong, nonatomic) NSArray *bytes;

@end
