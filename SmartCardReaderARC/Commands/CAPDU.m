//
//  CAPDU.m
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/5/18.
//

#import "CAPDU.h"
#import "NSArray+ByteManipulation.h"

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

-(void)replaceLengthByteWithCorrectLength:(NSNumber*)le
{
    self.le = le;
}

-(instancetype)initWithCAPDU:(CAPDU *)capdu
{
    self = [super init];
    if (self) {
        self.cla = capdu.cla;
        self.ins = capdu.ins;
        self.p1 = capdu.p1;
        self.p2 = capdu.p2;
    }
    
    return self;
}

-(instancetype)initWithCLA:(NSNumber*)cla
                       INS:(NSNumber*)ins
                        p1:(NSNumber*)p1
                        p2:(NSNumber*)p2
{
    self = [super init];
    if (self) {
        self.cla = cla;
        self.ins = ins;
        self.p1 = p1;
        self.p2 = p2;
    }
    
    return self;
}

-(instancetype)initWithCLA:(NSNumber*)cla
                       INS:(NSNumber*)ins
                        p1:(NSNumber*)p1
                        p2:(NSNumber*)p2
    expectedResponseLength:(NSNumber*)le
{
    self = [self initWithCLA:cla
                         INS:ins
                          p1:p1
                          p2:p2];
    if (self){
        self.le = le;
    }
    
    return self;
}

-(instancetype)initWithCLA:(NSNumber*)cla
                       INS:(NSNumber*)ins
                        p1:(NSNumber*)p1
                        p2:(NSNumber*)p2
               commandData:(NSArray*)commandData
{
    self = [self initWithCLA:cla
                         INS:ins
                          p1:p1
                          p2:p2];
    if (self) {
        self.lc = [NSNumber numberWithInteger:commandData.count];
        self.commandData = commandData;
    }
    
    return self;
}

-(instancetype)initWithCLA:(NSNumber*)cla
                       INS:(NSNumber*)ins
                        p1:(NSNumber*)p1
                        p2:(NSNumber*)p2
               commandData:(NSArray*)commandData
    expectedResponseLength:(NSNumber*)le
{
    self = [self initWithCLA:cla
                         INS:ins
                          p1:p1
                          p2:p2
                 commandData:commandData];
    if (self) {
        self.le = le;
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
