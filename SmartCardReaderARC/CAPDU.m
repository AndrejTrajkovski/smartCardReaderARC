//
//  CAPDU.m
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/5/18.
//

#import "CAPDU.h"
#import "NSArray+NSNumbersFromUnsignedCharArray.h"

@implementation CAPDU

-(void)replaceLengthByteWithCorrectLength:(Byte)le
{
    self.le = le;
    NSNumber *leNumber = [NSNumber numberWithUnsignedChar:le];
    self.bytes = [self.bytes arrayByAddingObject:leNumber];
}

-(instancetype)initWithCLA:(Byte)cla
                       INS:(Byte)ins
                        p1:(Byte)p1
                        p2:(Byte)p2
{
    self = [super init];
    if (self) {
        
        self.cla = cla;
        self.ins = ins;
        self.p1 = p1;
        self.p2 = p2;
        
        NSNumber *claNumber = [NSNumber numberWithUnsignedChar:cla];
        NSNumber *insNumber = [NSNumber numberWithUnsignedChar:ins];
        NSNumber *p1Number = [NSNumber numberWithUnsignedChar:p1];
        NSNumber *p2Number = [NSNumber numberWithUnsignedChar:p2];
        
        self.bytes = @[claNumber, insNumber, p1Number, p2Number];
    }
    return self;
}

-(instancetype)initWithCLA:(Byte)cla
                       INS:(Byte)ins
                        p1:(Byte)p1
                        p2:(Byte)p2
             commandLength:(Byte)lc
               commandData:(Byte *)commandData
{
    self = [self initWithCLA:cla
                         INS:ins
                          p1:p1
                          p2:p2];
    if (self) {
        
        self.lc = lc;
        NSNumber *lcNumber = [NSNumber numberWithUnsignedChar:lc];
        self.bytes = [self.bytes arrayByAddingObject:lcNumber];

        int commandLengthInt = (int)lc;
        NSArray *commandDataArray = [[NSArray alloc] initFromCArray:commandData withCount:commandLengthInt];
        self.commandData = commandDataArray;
        self.bytes = [self.bytes arrayByAddingObjectsFromArray:commandDataArray];
    }
    return self;
}

-(instancetype)initWithCLA:(Byte)cla
                       INS:(Byte)ins
                        p1:(Byte)p1
                        p2:(Byte)p2
             commandLength:(Byte)lc
               commandData:(Byte *)commandData
    expectedResponseLength:(Byte)le
{
    self = [self initWithCLA:cla
                         INS:ins
                          p1:p1
                          p2:p2
               commandLength:lc
                 commandData:commandData];
    
    if (self) {
        self.le = le;
        NSNumber *leNumber = [NSNumber numberWithUnsignedChar:le];
        self.bytes = [self.bytes arrayByAddingObject:leNumber];
    }
    return self;
}

@end
