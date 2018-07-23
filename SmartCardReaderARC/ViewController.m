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
    
    [self readPublicData];
}

#pragma mark - Notification handler
// handles smart card slot events.
- (void) cardEventHandler: (NSNotification *)notif
{
    // check if the card is inserted...
    if ([@"PB_CARD_INSERTED" compare:(NSString*)[notif name]] == 0)
    {
        [self readPublicData];
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
    [self readPublicData];
}

// Called when the system sends an EAAcessoryDidDisconnectNotification for a Tactivo device.
- (void)pbAccessoryDidDisconnect
{
    [self printStatus:@"Precise Biometrics Tactivo ABSENT"];
}

#pragma mark - Read Public Data
-(void)readPublicData
{
    NSError *error = nil;
    TactivoExecutioner *tactivoExecutioner = [TactivoExecutioner new];
    BOOL success = [tactivoExecutioner prepareCard:&error];
    if (success) {
        self.pdReader = [[PublicDataReader alloc] initWithExecutioner:tactivoExecutioner];
        NSString *publicData = [self.pdReader readPublicDataViaPSEWithError:&error];
        if (!publicData) {
            [self printStatus:error.localizedDescription];
        }else{
            [self printStatus:publicData];
        }
    }else{
        [self printStatus:error.localizedDescription];
    }
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
