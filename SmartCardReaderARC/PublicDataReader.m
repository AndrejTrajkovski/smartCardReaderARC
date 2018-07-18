//
//  CommandProcessor.m
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import "PublicDataReader.h"
#import "CAPDU.h"
#import "RAPDU.h"
#import "NSArray+ByteManipulation.h"
#import "CAPDUGenerator.h"
#import "RAPDUParser.h"
#import "NSData+ByteManipulation.h"

@interface PublicDataReader()

@property (strong, nonatomic) RAPDUParser *rapduParser;

@end

@implementation PublicDataReader
{
}

-(instancetype)initWithExecutioner:(id<CardReaderCommandExecutioner>)commandExecutioner
{
    self = [super init];
    
    if (self) {
        
        self.rapduParser = [RAPDUParser new];
        self.commandExecutioner = commandExecutioner;
    }
    
    return self;
}

-(void)selectPSEDir
{
    CAPDU *selectPSE = [CAPDUGenerator selectPSEDirectory];
    RAPDU *response = [self.commandExecutioner executeCommand:selectPSE];
    NSData *responseBytes = [NSData byteDataFromArray:response.bytes];
    NSNumber* sfi = [self.rapduParser sfiFromData:responseBytes];
    
    CAPDU *readRecord = [CAPDUGenerator readRecordWithRecordNumber:@0x01 andSFI:sfi];
    RAPDU *responseReadRecord = [self.commandExecutioner executeCommand:readRecord];
    NSData *responseReadRecordBytes = [NSData byteDataFromArray:responseReadRecord.bytes];
    NSArray *aidArray = [self.rapduParser aidFromData:responseReadRecordBytes];
    
    CAPDU *selectAid = [CAPDUGenerator selectApplicationWithAID:aidArray];
    RAPDU *selectAidResponse = [self.commandExecutioner executeCommand:selectAid];
    
}

-(void)selectPPSEDir
{
    CAPDU *selectPPSE = [CAPDUGenerator selectPPSEDirectory];
    RAPDU *reponse = [self.commandExecutioner executeCommand:selectPPSE];
}

-(void)selectAID
{
}

@end
