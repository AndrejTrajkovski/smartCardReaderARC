//
//  EIDTlv.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/1/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BerTag;

@interface EIDTlv : NSObject

-(instancetype)initWithBerTag:(BerTag *)berTag
                      andName:(NSString *)name;
@property (strong, nonatomic) BerTag *tag;
@property (strong, nonatomic) NSString *name;

@end
