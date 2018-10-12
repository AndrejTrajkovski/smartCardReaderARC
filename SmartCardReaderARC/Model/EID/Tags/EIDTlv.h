//
//  EIDTlv.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/1/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BerTag;

typedef enum {
    ValueTypeText,
    ValueTypeNumeric,
    ValueTypeImage
} ValueType;

@interface EIDTlv : NSObject

-(instancetype)initWithBerTag:(BerTag *)berTag
                      andName:(NSString *)name
                 andValueType:(ValueType)valueType;
@property (strong, nonatomic) BerTag *tag;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) ValueType valueType;

@end
