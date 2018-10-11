//
//  EmvAID.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/27/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardAID : NSObject

//application identifier

@property (strong, nonatomic) NSArray *aid;
@property (strong, nonatomic) NSString *vendor;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSString *type;

-(instancetype)initFromCSVArray:(NSArray *)csvArray;
-(instancetype)initFromArray:(NSArray *)array;

@end
