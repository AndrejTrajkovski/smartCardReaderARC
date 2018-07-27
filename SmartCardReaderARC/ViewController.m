//
//  ViewController.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/15/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "ViewController.h"
#import "PBAccessory.h"
#import "CAPDU.h"
#import "PublicDataReader.h"
#import "TactivoExecutioner.h"
#import "EmvAIDList.h"
#import "CHCSVParser.h"
#import "EmvAID.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
// use the accessory to quickly check if we have a Precise Biometrics accessory connected
@property (strong, nonatomic) PBAccessory *accessory;
// the smart card reader object used to communicate with the smart card
@property (strong, nonatomic) PublicDataReader *pdReader;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // add observers for the smart card event notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardEventHandler:) name:@"PB_CARD_REMOVED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardEventHandler:) name:@"PB_CARD_INSERTED" object:nil];
    
    // get the shared accessory object
    self.accessory = [PBAccessory sharedClass];
    
    // listen to Tactivo connect/disconnect notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pbAccessoryDidConnect) name:PBAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pbAccessoryDidDisconnect) name:PBAccessoryDidDisconnectNotification object:nil];
    
    // check if the Tactivo device is currently connected
    if (self.accessory.connected)
    {
        [self printStatus:@"Precise Biometrics Tactivo PRESENT"];
    }
    else
    {
        [self printStatus:@"Precise Biometrics Tactivo ABSENT"];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self readPublicData];
    });
}

#pragma mark - Notification handler
// handles smart card slot events.
- (void) cardEventHandler: (NSNotification *)notif
{
    // check if the card is inserted...
    if ([@"PB_CARD_INSERTED" compare:(NSString*)[notif name]] == 0)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self readPublicData];
        });
    }
    // ...or if the card is removed.
    else if ([@"PB_CARD_REMOVED" compare:(NSString*)[notif name]] == 0)
    {
        [self printStatus:@"Insert smart card..."];
    }
}

#pragma mark - PBAccessory notification handlers
// Called when the system sends an EAAcessoryDidConnectNotification for a Tactivo device.
- (void)pbAccessoryDidConnect
{
    [self printStatus:@"Precise Biometrics Tactivo PRESENT"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self readPublicData];
    });
}

// Called when the system sends an EAAcessoryDidDisconnectNotification for a Tactivo device.
- (void)pbAccessoryDidDisconnect
{
    [self printStatus:@"Precise Biometrics Tactivo ABSENT"];
}

#pragma mark - Read Public Data
-(void)readPublicData
{
    [self printStatus:@"Reading public data..."];
    NSMutableString *statusString = [NSMutableString new];
    NSError *cardConnectError = nil;
    TactivoExecutioner *tactivoExecutioner = [TactivoExecutioner new];
    BOOL success = [tactivoExecutioner prepareCard:&cardConnectError];
    if (success) {
        //card and reader connected
        self.pdReader = [[PublicDataReader alloc] initWithExecutioner:tactivoExecutioner];
        
//        NSError *pseError = nil;
//        //try via pse
//        NSString *publicData = [self.pdReader readPublicDataViaPSEWithError:&pseError];
//        if (!publicData) {
//            [statusString appendString:[NSString stringWithFormat:@"PSE : \n%@\n", pseError.localizedDescription]];
//        }else{
//            [statusString appendString:[NSString stringWithFormat:@"PSE : \n%@\n", publicData]];
//        }
//
//        NSError *aidError = nil;
//        //try via AID
//        NSString *publicDataViaAid = [self readPublicDataViaAIDsError:&aidError];
//        if (!publicDataViaAid) {
//            [statusString appendString:[NSString stringWithFormat:@"AID : \n%@\n", aidError.localizedDescription]];
//        }else{
//            [statusString appendString:[NSString stringWithFormat:@"AID : \n%@\n", publicDataViaAid]];
//        }
        
        NSError *ppseError = nil;
        //try via pse
        NSString *publicData = [self.pdReader readPublicDataViaPPSEWithError:&ppseError];
        if (!publicData) {
            [statusString appendString:[NSString stringWithFormat:@"PSE : \n%@\n", ppseError.localizedDescription]];
        }else{
            [statusString appendString:[NSString stringWithFormat:@"PSE : \n%@\n", publicData]];
        }

        
    }else{
        [statusString appendString:cardConnectError.localizedDescription];
    }
    
    [self printStatus:statusString];
}

-(NSString *)readPublicDataViaAIDsError:(NSError **)error
{
//    NSArray *aidList = @[
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x00,@0x00,@0x00],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x05,@0x07,@0x60,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x10,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x10,@0x10,@0x01],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x10,@0x10,@0x02],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x20,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x20,@0x20],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x30,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x40,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x50,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x53,@0x44,@0x41],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x53,@0x50],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x53,@0x50,@0x41],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x60,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x60,@0x20],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x80,@0x02],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x80,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x90,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x99,@0x99,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x00,@0x00],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x01],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x10,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x10,@0x10,@0x12,@0x13],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x10,@0x10,@0x12,@0x15],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x10,@0x10,@0xBB,@0x54,@0x49,@0x43,@0x53,@0x01],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x20,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x30,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x30,@0x60],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x30,@0x60,@0x01],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x40,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x50,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x55,@0x55],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x60,@0x00],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x80,@0x02],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x99,@0x99],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x05,@0x00,@0x01],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x05,@0x00,@0x02],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x03,@0x20,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x10,@0x10],
//        @[@0xA0,@0x00,@0x00,@0x00,@0x04,@0x30,@0x60]
//        ];
    
    NSArray *aidList = [EmvAIDList list];
    
    NSString *pd;
    for (int i = 0; i < aidList.count; i++) {
        EmvAID *aid = aidList[i];
        NSArray *aidAsNSNumbersArray = [aid aidAsNSNumbersArray];
        NSString *publicData = [self.pdReader readPublicDataForAID:aidAsNSNumbersArray error:error];
        if (publicData) {
            pd = publicData;
            break;
        }
    }
    
    return pd;
}

-(void)printStatus:(NSString *)status
{
    if([NSThread isMainThread] == FALSE)
    {
        // invoke this method on the main thread instead
        [self performSelectorOnMainThread:@selector(printStatus:) withObject:status waitUntilDone:FALSE];
        return;
    }
    self.statusTextView.text = status;
}

@end
