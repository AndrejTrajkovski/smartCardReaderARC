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
#import "CommandProcessor.h"
#import "PBSmartcard.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    unsigned char select_aid_pdu[] = {
        //0x00, 0xA4, 0x04, 0x00,
        //visa electron
        //size
        //0x07,
        //aid visa el
//        0xA0, 0x00, 0x00, 0x00, 0x03, 0x20, 0x10
        //aid master card
        0xA0, 0x00, 0x00, 0x00, 0x04, 0x10, 0x10
    };
    unsigned char cla = 0x00;
    unsigned char ins = 0xA4;
    unsigned char p1 = 0x04;
    unsigned char p2 = 0x00;
    unsigned char lc = 0x07;
    
    CAPDU *selectAidPDU = [[CAPDU alloc] initWithCLA:cla
                                                 INS:ins
                                                  p1:p1
                                                  p2:p2
                                       commandLength:lc
                                         commandData:select_aid_pdu];
    PBSmartcardStatus status;
    PBSmartcard *smartcard = [[PBSmartcard alloc] init];
    status = [smartcard open];
    NSLog(@"Open result : %@", [PBSmartcard stringFromStatus:status]);
    status = [smartcard connect:PBSmartcardProtocolTx];
    NSLog(@"Connect result : %@", [PBSmartcard stringFromStatus:status]);
    
    CommandProcessor *cp = [[CommandProcessor alloc] initWithCommandFlow:@[selectAidPDU]
                                                            andSmartCard:smartcard];
    [cp start];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
