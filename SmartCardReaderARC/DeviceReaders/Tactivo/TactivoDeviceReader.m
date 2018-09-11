//
//  TactivoExecutioner.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/18/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "TactivoDeviceReader.h"
#import "PBSmartcard.h"
#import "DeviceReader.h"
#import "CAPDU.h"
#import "RAPDU.h"
#import "NSArray+ByteManipulation.h"

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

    self.smartCard = [[PBSmartcard alloc] init];
    __block PBSmartcardStatus status;
    
    status = [self.smartCard open];
    
    if (status == PBSmartcardStatusSuccess) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            status = [self.smartCard connect:PBSmartcardProtocolTx];
        });
    }
    
    if (status != PBSmartcardStatusSuccess) {
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[PBSmartcard stringFromStatus:status] forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"Tactivo Reader Error" code:200 userInfo:details];
        
        [self.delegate didFailPrepareCardWithError:error];
    }
    
    [self.delegate didPrepareCardSuccessfully];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PB_CARD_REMOVED" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PB_CARD_INSERTED" object:nil];
    
    PBSmartcardStatus status = [self.smartCard disconnect:PBSmartcardDispositionLeaveCard];
    status = [self.smartCard close];
    
    if (status != PBSmartcardStatusSuccess) {
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[PBSmartcard stringFromStatus:status] forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"Tactivo Reader Error" code:200 userInfo:details];
        
        [self.delegate didFailFinalizeCardWithError:error];
    }
    
    [self.delegate didFinalizeCardSuccessfully];
}

#pragma mark - Notification handler
// handles smart card slot events.
- (void) cardEventHandler: (NSNotification *)notif
{
    // check if the card is inserted...
    if ([@"PB_CARD_INSERTED" compare:(NSString*)[notif name]] == 0)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self readPublicData];
        });
    }
    // ...or if the card is removed.
    else if ([@"PB_CARD_REMOVED" compare:(NSString*)[notif name]] == 0)
    {
//        [self printStatus:@"Insert smart card..."];
    }
}

#pragma mark - Dealloc

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PB_CARD_REMOVED" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PB_CARD_INSERTED" object:nil];
}

@end
