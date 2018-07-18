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

@property (strong, nonatomic) PublicDataReader *pdReader;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TactivoExecutioner *tactivoExecutioner = [TactivoExecutioner new];
    [tactivoExecutioner doInitialization];
    self.pdReader = [[PublicDataReader alloc] initWithExecutioner:tactivoExecutioner];
    [self.pdReader selectPSEDir];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
