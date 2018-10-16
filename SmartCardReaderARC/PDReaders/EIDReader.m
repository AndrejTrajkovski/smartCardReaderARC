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
    
    NSError *error = nil;
    RAPDU *selectAID = [self selectApplicationWithError:&error];
    //Ignore RAPDU.responseStatus, the flow on EID does not care about wrong statuses
    if (!selectAID) {
        [self.delegate didFailToReadPublicDataWithError:error];
        return;
    }
    //App is selected, continue with selecting files and reading files
    NSArray *filesList = [self filesList];
    [filesList enumerateObjectsUsingBlock:^(EIDBaseFile* file, NSUInteger idx, BOOL * _Nonnull stop) {
        [self selectFileWithId:file.fileId];
        file.bytes = [self readSelectedFile];
    }];
    
    EIDCardAdapter *cardAdapter = [[EIDCardAdapter alloc] initWithParser:[EIDParser new]];
    EIDCardModel *card = [cardAdapter cardModelForFiles:filesList];
    [self.delegate didReadPublicData:card];
}

-(NSArray<EIDBaseFile*> *)filesList
{
    EIDFileOne *fileOne = [EIDFileOne new];
    EIDFileTwo *fileTwo = [EIDFileTwo new];
    EIDFileThree *fileThree = [EIDFileThree new];
    EIDFileFour *fileFour = [EIDFileFour new];
    EIDFileFive *fileFive = [EIDFileFive new];
    EIDFileSix *fileSix = [EIDFileSix new];
    
    return @[fileOne, fileTwo, fileThree, fileFour, fileFive, fileSix];
}

-(RAPDU *)selectFileWithId:(NSArray <NSNumber *>*)identifier
{
    NSError *readFileError = nil;
    CAPDU *selectFile = [CAPDUGenerator selectEmiratesCardFileWithFID:identifier];
    RAPDU *selectFileResponse = [self.deviceReader executeCommand:selectFile error:&readFileError];
    return selectFileResponse;
}

-(RAPDU *)selectApplicationWithError:(NSError **)error
{
    NSArray *emiratesCardAID = @[@0xA0, @0x00, @0x00, @0x02, @0x43, @0x00, @0x13, @0x00, @0x00, @0x00, @0x01, @0x01, @0x01];
    CAPDU *selectEmiratesAID = [CAPDUGenerator selectApplicationWithAID:emiratesCardAID];
    
    NSError *underlyingError = nil;
    RAPDU *selectCardResponse = [self.deviceReader executeCommand:selectEmiratesAID error:&underlyingError];
    return selectCardResponse;
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
