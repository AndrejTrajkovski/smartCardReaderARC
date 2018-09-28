//
//  EIDReader.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 9/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "EIDReader.h"
#import "CardAID.h"
#import "RAPDUParser.h"
#import "CAPDUGenerator.h"
#import "CAPDU.h"
#import "RAPDU.h"

@interface EIDReader() <DeviceReaderDelegate>

@property (strong, nonatomic) RAPDUParser *rapduParser;

@end

@implementation EIDReader

@synthesize delegate;

@synthesize deviceReader;

- (instancetype)initWithDeviceReader:(id<DeviceReader>)deviceReader andDelegate:(id<PDReaderDelegate>)delegate {
    
    self = [super init];
    
    if (self) {
        
        self.delegate = delegate;
        self.deviceReader = deviceReader;
        self.deviceReader.delegate = self;
        self.rapduParser = [RAPDUParser new];
    }
    
    return self;
}

- (void)readPublicData {
    
    [self.deviceReader prepareCard];
    
}

#pragma mark - DeviceReaderDelegate

- (void)didFailFinalizeCardWithError:(NSError *)error {
    
}

- (void)didFailPrepareCardWithError:(NSError *)error {
    
}

- (void)didFinalizeCardSuccessfully {
    
}

- (void)didPrepareCardSuccessfully {
    
    NSError *error = nil;
    RAPDU *selectAID = [self selectApplicationWithError:&error];
    
    if (!selectAID) {
        [self.delegate didFailToReadPublicDataWithError:error];
        return;
    }
    
    NSError *readFileError = nil;
    CAPDU *selectFile = [CAPDUGenerator selectEmiratesCardFileWithFID:@[@0x02, @0x02]];
    CAPDU *readFile = [CAPDUGenerator read];
    
    RAPDU *selectFileResponse = [self.deviceReader executeCommand:selectFile error:&readFileError];
    RAPDU *readFileResponse = [self.deviceReader executeCommand:readFile error:&readFileError];
    
//    CAPDU *file2 = [CAPDUGenerator selectEmiratesCardFileWithFID:@[@0x02, @0x02]];
//    CAPDU *file3 = [CAPDUGenerator selectEmiratesCardFileWithFID:@[@0x02, @0x03]];
//    CAPDU *file4 = [CAPDUGenerator selectEmiratesCardFileWithFID:@[@0x02, @0x05]];
//    CAPDU *file5 = [CAPDUGenerator selectEmiratesCardFileWithFID:@[@0x02, @0x07]];
//    CAPDU *file6 = [CAPDUGenerator selectEmiratesCardFileWithFID:@[@0x02, @0x01]];

}

-(RAPDU *)selectApplicationWithError:(NSError **)error
{
    NSArray *emiratesCardAID = @[@0xA0, @0x00, @0x00, @0x02, @0x43, @0x00, @0x13, @0x00, @0x00, @0x00, @0x01, @0x01, @0x01];
    CAPDU *selectEmiratesAID = [CAPDUGenerator selectApplicationWithAID:emiratesCardAID];
    
    NSError *underlyingError = nil;
    RAPDU *selectCardResponse = [self.deviceReader executeCommand:selectEmiratesAID error:&underlyingError];
//    selectCardResponse = [self executeCorrectedLengthCAPDU:selectEmiratesAID withRapdu:selectCardResponse error:&underlyingError];
//
//    if (!selectCardResponse) {
//        NSMutableDictionary* details = [NSMutableDictionary dictionary];
//        [details setValue:@"Cannot read public data." forKey:NSLocalizedDescriptionKey];
//        *error = [NSError errorWithDomain:ReadingPublicDataErrorDomain
//                                     code:ReadingPublicDataErrorCodeSelectAID
//                                 userInfo:details];
//    }
//
    return selectCardResponse;
}
#pragma mark - Read Public Data

-(RAPDU *)executeCorrectedLengthCAPDU:(CAPDU *)capdu withRapdu:(RAPDU *)rapdu error:(NSError **)error
{
    if (rapdu.bytes.count > 1) {
        
        NSNumber *byteBeforeLast = [rapdu byteBeforeLast];
        NSNumber *lastByte = [rapdu lastByte];
        
        if ([byteBeforeLast isEqual:@0x61]) {
            
            //response bytes still available
            CAPDU *commandToExecute = [CAPDUGenerator getResponseWithLength:lastByte];
            rapdu = [self.deviceReader executeCommand:commandToExecute error:error];
            
        }else if ([byteBeforeLast isEqual:@0x6C] || [byteBeforeLast isEqual:@0x67]){
            
            //same commmand, just fixed length
            CAPDU *commandToExecute = [CAPDUGenerator capduWithCAPDU:capdu withFixedLength:lastByte];
            rapdu = [self.deviceReader executeCommand:commandToExecute error:error];
            
        }
    }
    
    return rapdu;
}

@end
