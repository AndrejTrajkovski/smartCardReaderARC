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
#import "EIDParser.h"
#import "EIDFileOne.h"
#import "NSArray+ByteManipulation.h"
@interface ViewController () <SmartEIDDelegate>

@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (strong, nonatomic) SmartEID *smartEid;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.smartEid = [[SmartEID alloc] initWithDelegate:self];
//    [self.smartEid readPublicData];
//
    const char byteArray[19] = {
//        0x70,0x01,0x00,0x20,
        
        0xe1,0x01,0x00,0x0F,
        0x37,0x38,0x34,0x31,
        0x39,0x37,0x34,0x34,
        0x31,0x35,0x30,0x33,
        0x38,0x33,0x32,
        
//        0xe1,0x02,0x00,0x09,
//        0x30,0x30,0x30,0x30,
//        0x31,0x31,0x35,0x38,
//        0x32
    };
    NSData *data = [NSData dataWithBytes:byteArray length:19];
    EIDFileOne *fileOne = [[EIDFileOne alloc] init];
    fileOne.bytes = [NSArray byteArrayFromData:data];
    
    EIDParser *parser = [EIDParser new];
    NSData *dataaaa = [parser datainFile:fileOne];
    
    NSString *lastresult = [[NSString alloc] initWithData:dataaaa encoding:NSASCIIStringEncoding];
//    BerTlv *cardNUmber = [[BerTlv alloc] init:[EIDBerTags CARD_NUMBER] value:byteArray];
//    NSLog("card number : %@", cardNUmber.value);
//    BerTlv *fileBerTlv = [parser parseConstructed:fileData];
//    BerTag *cardNumberBerTag = [EIDBerTags CARD_NUMBER];
//    BerTlv *cardNumberBerTlv = [fileBerTlv find:cardNumberBerTag];
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
