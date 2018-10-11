//
//  ViewController.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/15/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "ViewController.h"
#import "SmartEID.h"

#import "BerTlv.h"
#import "BerTlvParser.h"
#import "BerTag.h"
#import "EidTlvList.h"
#import "EIDBerTags.h"
#import "BerTlvs.h"
//#import "lbrReader.h"

@interface ViewController () <SmartEIDDelegate>

@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (strong, nonatomic) SmartEID *smartEid;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.smartEid = [[SmartEID alloc] initWithDelegate:self];
//    [self.smartEid readPublicData];
    
    BerTag *baseTag = [[BerTag alloc] init:0x70 secondByte:0x01];
    BerTlvParser *parser = [[BerTlvParser alloc] init];
    
    const char byteArray[39] = {
        0x70,0x01,0x00,0x20,
        
        0xe1,0x01,0x00,0x0F,
        0x37,0x38,0x34,0x31,
        0x39,0x37,0x34,0x34,
        0x31,0x35,0x30,0x33,
        0x38,0x33,0x32,
        
        0xe1,0x02,0x00,0x09,
        0x30,0x30,0x30,0x30,
        0x31,0x31,0x35,0x38,
        0x32
    };
    
    NSData *fileData = [[NSData alloc] initWithBytes:byteArray length:39];
//    BerTlvs *fileBerTlv = [parser parseTlvs:fileData];
    BerTlv *fileBerTlv = [parser parseConstructed:fileData];
    BerTag *cardNumberBerTag = [EIDBerTags CARD_NUMBER];
    BerTlv *cardNumberBerTlv = [fileBerTlv find:cardNumberBerTag];
    NSLog(@"card number: %@", cardNumberBerTlv.textValue);
}

#pragma mark - SmartEID Delegate

-(void)didReadPublicData:(id)publicData
{
    
}

-(void)didFailReadPublicData:(NSError *)error
{
    
}

-(void)didConnectDeviceReader
{
    
}

-(void)didDisonnectDeviceReader
{
    
}

-(void)didInsertCard
{
    
}

-(void)didRemoveCard
{
    
}

@end
