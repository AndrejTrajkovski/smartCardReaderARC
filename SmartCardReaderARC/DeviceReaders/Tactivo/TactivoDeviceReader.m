#import "TactivoDeviceReader.h"
#import "PBSmartcard.h"
#import "DeviceReader.h"
#import "CAPDU.h"
#import "RAPDU.h"
#import "NSArray+ByteManipulation.h"
#import "NotificationConstants.h"

@interface TactivoDeviceReader()

@property (strong, nonatomic) PBSmartcard *smartCard;

@end

@implementation TactivoDeviceReader

@synthesize delegate;

-(void)prepareCard
{
    // observers when card inserted/removed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardEventHandler:) name:@"PB_CARD_REMOVED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardEventHandler:) name:@"PB_CARD_INSERTED" object:nil];

    dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {

        self.smartCard = [[PBSmartcard alloc] init];
        __block PBSmartcardStatus status;
        
        status = [self.smartCard open];
        
        if (status == PBSmartcardStatusSuccess) {
            status = [self.smartCard connect:PBSmartcardProtocolTx];
        }
        
        if (status != PBSmartcardStatusSuccess) {
            
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:[PBSmartcard stringFromStatus:status] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"Tactivo Reader Error" code:200 userInfo:details];
            
            [self.delegate didFailPrepareCardWithError:error];
        }
        
        [self.delegate didPrepareCardSuccessfully];
        
    });
}

-(RAPDU *)executeCommand:(CAPDU *)capdu error:(NSError **)error
{
    unsigned char buffer[255] = {0};
    unsigned char *command = [capdu.bytes cArrayFromBytes];
    unsigned short rdl;
    rdl = sizeof(buffer);
    
    PBSmartcardStatus status = [self.smartCard transmit:command
                                      withCommandLength:capdu.bytes.count
                                      andResponseBuffer:buffer
                                      andResponseLength:&rdl];
    int responseLength = (int)rdl;
    
    if (status != PBSmartcardStatusSuccess) {
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[PBSmartcard stringFromStatus:status] forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:@"Tactivo Reader Error" code:200 userInfo:details];
        }
        
        return nil;
    }
    
    RAPDU *responseAPDU = [[RAPDU alloc] initWithResponseBytes:buffer
                                                     andLength:responseLength];
    
    if (responseAPDU.responseStatus == RAPDUStatusOther) {
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[NSString stringWithFormat:@"ERROR FOR CAPDU: %@.\nRAPDU STATUS BYTES: %c %c", capdu.bytes, responseAPDU.byteBeforeLast.unsignedShortValue, responseAPDU.lastByte.unsignedShortValue] forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:@"Error Reading From Card" code:200 userInfo:details];
        }
        
        return nil;
        
    }else if (responseAPDU.responseStatus == RAPDUStatusNoBytes) {
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[PBSmartcard stringFromStatus:status] forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:@"Tactivo Reader Error" code:200 userInfo:details];
        }
        
        return nil;
    }
    
    return responseAPDU;
}

-(void)finalizeCard
{
    PBSmartcardStatus status = [self.smartCard disconnect:PBSmartcardDispositionLeaveCard];
    status = [self.smartCard close];
    
    if (status != PBSmartcardStatusSuccess) {
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[PBSmartcard stringFromStatus:status] forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"Tactivo Reader Error" code:200 userInfo:details];
        
        [self.delegate didFailFinalizeCardWithError:error];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PB_CARD_REMOVED" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PB_CARD_INSERTED" object:nil];

    [self.delegate didFinalizeCardSuccessfully];
}

#pragma mark - Notification handler

- (void) cardEventHandler: (NSNotification *)notif
{
    if ([@"PB_CARD_INSERTED" compare:(NSString*)[notif name]] == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:DidInsertCardNotification
                                                            object:nil];
    }
    else if ([@"PB_CARD_REMOVED" compare:(NSString*)[notif name]] == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:DidRemoveCardNotification
                                                            object:nil];
    }
}

#pragma mark - Dealloc

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PB_CARD_REMOVED" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PB_CARD_INSERTED" object:nil];
}

@end
