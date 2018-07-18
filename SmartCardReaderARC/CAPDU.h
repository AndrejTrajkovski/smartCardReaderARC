//
//  CAPDU.h
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/5/18.
//

#import "APDU.h"

@interface CAPDU : APDU

@property (strong, nonatomic) NSNumber* cla;
@property (strong, nonatomic) NSNumber* ins;
@property (strong, nonatomic) NSNumber* p1;
@property (strong, nonatomic) NSNumber* p2;
@property (strong, nonatomic) NSNumber* lc;
@property (strong, nonatomic) NSArray* commandData;
@property (strong, nonatomic) NSNumber* le;

-(instancetype)initWithCLA:(NSNumber*)cla
                       INS:(NSNumber*)ins
                        p1:(NSNumber*)p1
                        p2:(NSNumber*)p2;

-(instancetype)initWithCLA:(NSNumber*)cla
                       INS:(NSNumber*)ins
                        p1:(NSNumber*)p1
                        p2:(NSNumber*)p2
    expectedResponseLength:(NSNumber*)le;

-(instancetype)initWithCLA:(NSNumber*)cla
                       INS:(NSNumber*)ins
                        p1:(NSNumber*)p1
                        p2:(NSNumber*)p2
               commandData:(NSArray*)commandData;

-(instancetype)initWithCLA:(NSNumber*)cla
                       INS:(NSNumber*)ins
                        p1:(NSNumber*)p1
                        p2:(NSNumber*)p2
               commandData:(NSArray*)commandData
    expectedResponseLength:(NSNumber*)le;

@end
