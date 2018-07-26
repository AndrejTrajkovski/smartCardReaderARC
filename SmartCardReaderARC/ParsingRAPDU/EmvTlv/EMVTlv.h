//
//  EMVTlv.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/23/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BerTag;
typedef enum TagValueType : NSUInteger {
    Binary,
    Numeric,
    Text,
    Mixed,
    DOL,
    Template
} TagValueType;

@interface EMVTlv : NSObject

@property (assign, nonatomic) TagValueType type;
@property (strong, nonatomic) BerTag *tag;
@property (strong, nonatomic) NSString *name;

-(instancetype)initWithBerTag:(BerTag *)berTag
                      andType:(TagValueType)type
                      andName:(NSString *)name;

@end
