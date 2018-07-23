//
//  VisaElectronPDParsingTest.m
//  SmartCardReaderARCTests
//
//  Created by Andrej Trajkovski on 7/23/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RAPDUParser.h"

@interface VisaElectronPDParsingTest : XCTestCase

@property (strong, nonatomic) NSData *visaElectronPDDataBytes;
@property (strong, nonatomic) RAPDUParser *rapduParser;
@end

@implementation VisaElectronPDParsingTest

- (void)setUp {
    [super setUp];
    
    NSURL *relativeURL = [[NSURL alloc] initFileURLWithPath:@"pd data example.rtf" relativeToURL:[[NSBundle bundleForClass:[self class]] bundleURL]];
    self.visaElectronPDDataBytes = [NSData dataWithContentsOfURL:relativeURL];
    self.rapduParser = [RAPDUParser new];
}

- (void)tearDown
{
    self.visaElectronPDDataBytes = nil;
    [super tearDown];
}

- (void)testExample
{
    NSString *parsedData = [self.rapduParser berTlvParseData:self.visaElectronPDDataBytes];
    XCTAssertEqual(parsedData, @"");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
