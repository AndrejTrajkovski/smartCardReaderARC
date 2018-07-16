//
//  CAPDU.h
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/5/18.
//

#import "APDU.h"

@interface CAPDU : APDU

-(instancetype)initWithCLA:(Byte)cla
                       INS:(Byte)ins
                        p1:(Byte)p1
                        p2:(Byte)p2;

-(instancetype)initWithCLA:(Byte)cla
                       INS:(Byte)ins
                        p1:(Byte)p1
                        p2:(Byte)p2
             commandLength:(Byte)lc
               commandData:(Byte *)commandData;

-(instancetype)initWithCLA:(Byte)cla
                       INS:(Byte)ins
                        p1:(Byte)p1
                        p2:(Byte)p2
             commandLength:(Byte)lc
               commandData:(Byte *)commandData
    expectedResponseLength:(Byte)le;

@property (assign, nonatomic) Byte cla;
@property (assign, nonatomic) Byte ins;
@property (assign, nonatomic) Byte p1;
@property (assign, nonatomic) Byte p2;
@property (assign, nonatomic) Byte lc;
@property (strong, nonatomic) NSArray* commandData;
@property (assign, nonatomic) Byte le;

@end
