//
//  TactivoExecutioner.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/18/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "TactivoExecutioner.h"
#import "PBSmartcard.h"
#import "CardReaderCommandExecutioner.h"
#import "CAPDU.h"
#import "RAPDU.h"
#import "NSArray+ByteManipulation.h"

@interface TactivoExecutioner()

@property (strong, nonatomic) PBSmartcard *smartCard;

@end

@implementation TactivoExecutioner

-(BOOL)prepareCard:(NSError **)error
{
    self.smartCard = [[PBSmartcard alloc] init];
    PBSmartcardStatus status;
    
    status = [self.smartCard open];
    
    if (status == PBSmartcardStatusSuccess) {
        status = [self.smartCard connect:PBSmartcardProtocolTx];
    }
    
    if (status != PBSmartcardStatusSuccess) {
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[PBSmartcard stringFromStatus:status] forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:@"Tactivo Reader Error" code:200 userInfo:details];
        }
        
        return NO;
    }
    
    return YES;
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

-(void)runCardReader:(void (^)(__autoreleasing id *))success andFailureBlock:(void (^)(NSError *))failure
{
    // add observers for the smart card event notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardEventHandler:) name:@"PB_CARD_REMOVED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardEventHandler:) name:@"PB_CARD_INSERTED" object:nil];

    // get the shared accessory object
    self.accessory = [PBAccessory sharedClass];

    // listen to Tactivo connect/disconnect notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pbAccessoryDidConnect) name:PBAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pbAccessoryDidDisconnect) name:PBAccessoryDidDisconnectNotification object:nil];

}

@end
