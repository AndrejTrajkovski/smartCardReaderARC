//
//  CAPDU.m
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/5/18.
//

#import "CAPDU.h"
#import "NSArray+NSNumbersFromUnsignedCharArray.h"

@interface CAPDU()

@property (strong, nonatomic) NSNumber* cla;
@property (strong, nonatomic) NSNumber* ins;
@property (strong, nonatomic) NSNumber* p1;
@property (strong, nonatomic) NSNumber* p2;
@property (strong, nonatomic) NSNumber* lc;
@property (strong, nonatomic) NSArray* commandData;
@property (strong, nonatomic) NSNumber* le;

@end

@implementation CAPDU

-(void)replaceLengthByteWithCorrectLength:(Byte)le
{
    self.le = [NSNumber numberWithUnsignedChar:le];
}

-(instancetype)initWithCLA:(Byte)cla
                       INS:(Byte)ins
                        p1:(Byte)p1
                        p2:(Byte)p2
{
    self = [super init];
    if (self) {
        self.cla = [NSNumber numberWithUnsignedChar:cla];
        self.ins = [NSNumber numberWithUnsignedChar:ins];
        self.p1 = [NSNumber numberWithUnsignedChar:p1];
        self.p2 = [NSNumber numberWithUnsignedChar:p2];
        
    }
    
    return self;
}

-(instancetype)initWithCLA:(Byte)cla
                       INS:(Byte)ins
                        p1:(Byte)p1
                        p2:(Byte)p2
    expectedResponseLength:(Byte)le
{
    self = [self initWithCLA:cla
                         INS:ins
                          p1:p1
                          p2:p2];
    if (self){
        self.le = [NSNumber numberWithUnsignedChar:le];
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
        self.lc = [NSNumber numberWithUnsignedChar:lc];
        int commandLengthInt = (int)lc;
        NSArray *commandDataArray = [[NSArray alloc] initFromCArray:commandData withCount:commandLengthInt];
        self.commandData = commandDataArray;
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
        self.le = [NSNumber numberWithUnsignedChar:le];
    }
    
    return self;
}

-(NSArray *)bytes{
    
    NSArray *finalBytes = @[];
    NSArray *headerBytes = @[self.cla, self.ins, self.p1, self.p2];
    finalBytes = headerBytes;
    if (self.lc) {
        finalBytes = [finalBytes arrayByAddingObject:self.lc];
    }
    if (self.commandData) {
        finalBytes = [finalBytes arrayByAddingObjectsFromArray:self.commandData];
    }
    if (self.le) {
        finalBytes = [finalBytes arrayByAddingObject:self.le];
    }
    return finalBytes;
}

@end
