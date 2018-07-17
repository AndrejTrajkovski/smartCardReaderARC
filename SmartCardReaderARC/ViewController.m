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
#import "PBSmartcard.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PBSmartcardStatus status;
    PBSmartcard *smartcard = [[PBSmartcard alloc] init];
    status = [smartcard open];
    status = [smartcard connect:PBSmartcardProtocolTx];
    
    PublicDataReader *pdr = [[PublicDataReader alloc] initWithSmartCard:smartcard];
    [pdr selectPSEDir];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
