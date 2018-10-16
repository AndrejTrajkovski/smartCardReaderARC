#import "EIDReader.h"
#import "CardAID.h"
#import "EMVParser.h"
#import "CAPDUGenerator.h"
#import "CAPDU.h"
#import "RAPDU.h"
#import "EIDCardModel.h"
#import "NSData+ByteManipulation.h"
#import "EIDFiles.h"
#import "EIDCardAdapter.h"
#import "EIDParser.h"
#import "AIDs.h"
#import "EIDBaseFile.h"

@interface EIDReader() <DeviceReaderDelegate>

@property (strong, nonatomic) EMVParser *rapduParser;

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
        self.rapduParser = [EMVParser new];
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
    
    
    AID01 *aid01 = [AID01 new];
    NSArray *aid01Files = [self readFilesForAID:aid01];
    
    AID09 *aid09 = [AID09 new];
    NSArray *aid09Files = [self readFilesForAID:aid09];
    
    NSMutableArray *allFiles = [NSMutableArray arrayWithArray:aid01Files];
    [allFiles addObjectsFromArray:aid09Files];
//    CAPDU *selectEmiratesAID = [CAPDUGenerator selectApplicationWithAID:firstAID.aid];
//    NSError *underlyingError = nil;
//    RAPDU *selectAIDRapdu = [self.deviceReader executeCommand:selectEmiratesAID error:&underlyingError];
//    //Ignore RAPDU.responseStatus, the flow on EID does not care about wrong statuses
//    if (!selectAIDRapdu) {
//        [self.delegate didFailToReadPublicDataWithError:error];
//        return;
//    }
//    //App is selected, continue with selecting files and reading files
//    NSArray *aid01Files = [firstAID filesList];
//    [aid01Files enumerateObjectsUsingBlock:^(EIDBaseFile* file, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self selectFileWithId:file.fileId];
//        file.bytes = [self readSelectedFile];
//    }];
    
    EIDCardAdapter *cardAdapter = [[EIDCardAdapter alloc] initWithParser:[EIDParser new]];
    EIDCardModel *card = [cardAdapter cardModelForFiles:allFiles];
    [self.delegate didReadPublicData:card];
}

-(NSArray <EIDBaseFile*>*)readFilesForAID:(id <BaseAID>)aid
{
    NSError *error = nil;
    CAPDU *selectEmiratesAID = [CAPDUGenerator selectApplicationWithAID:aid.aid];
    NSError *underlyingError = nil;
    RAPDU *selectAIDRapdu = [self.deviceReader executeCommand:selectEmiratesAID error:&underlyingError];
    //Ignore RAPDU.responseStatus, the flow on EID does not care about wrong statuses
    if (!selectAIDRapdu) {
        [self.delegate didFailToReadPublicDataWithError:error];
        return nil;
    }
    //App is selected, continue with selecting files and reading files
    NSArray *aidFiles = aid.filesList;
    [aidFiles enumerateObjectsUsingBlock:^(EIDBaseFile* file, NSUInteger idx, BOOL * _Nonnull stop) {
        [self selectFileWithId:file.fileId];
        file.bytes = [self readSelectedFile];
    }];
    return aidFiles;
}


-(RAPDU *)selectFileWithId:(NSArray <NSNumber *>*)identifier
{
    NSError *readFileError = nil;
    CAPDU *selectFile = [CAPDUGenerator selectEmiratesCardFileWithFID:identifier];
    RAPDU *selectFileResponse = [self.deviceReader executeCommand:selectFile error:&readFileError];
    return selectFileResponse;
}

-(NSArray *)readSelectedFile
{
    const NSInteger chunkSize = 230;
    NSInteger bytesRead = 0;
    NSInteger offset = 0;
    NSInteger nextLength = chunkSize;
    NSMutableArray *allBytes = [NSMutableArray new];
    
    while (nextLength != 0) {
        CAPDU *readFile = [CAPDUGenerator readEmiratesCardFileWithOffset:offset andLength:nextLength];
        RAPDU *readFileResponse = [self.deviceReader executeCommand:readFile error:nil];
        NSLog(@"read file response : %@", readFileResponse.bytes);
        switch (readFileResponse.responseStatus) {
            case RAPDUStatusSuccess:{
                nextLength = chunkSize;
                bytesRead = readFileResponse.bytes.count - 2;
                break;
            }
            case RAPDUStatusWrongLength:{
                nextLength = readFileResponse.lastByte.integerValue;
                bytesRead = 0;
                break;
            }
            case RAPDUStatusWrongP1P2:{
                nextLength = 0;
                bytesRead = 0;
                break;
            }
            default:
                break;
        }
        
        NSArray *bytesWithoutStatus = [readFileResponse bytesWithoutStatus];
        [allBytes addObjectsFromArray:bytesWithoutStatus];
        offset += bytesRead;
    }
    
    return [NSArray arrayWithArray:allBytes];
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
