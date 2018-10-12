#import <XCTest/XCTest.h>
#import "EIDParser.h"
#import "EIDFileOne.h"
#import "EidTlvList.h"

@interface EIDParserTest : XCTestCase

@end

@implementation EIDParserTest {
    EIDParser *eidParser;
    EIDFileOne *fileOne;
    NSString *kirilMilevCardNumber;
    NSString *kirilMilevIdNumber;
}

- (void)setUp
{
    [super setUp];
    eidParser = [EIDParser new];
    
    kirilMilevCardNumber = @"0000011582";
    kirilMilevIdNumber = @"784197441503832";
    
    NSArray *fileOneBytes = @[@0x70,@0x01,@0x00,@0x20,
                            @0xe1,@0x01,@0x00,@0x0F,
                            @0x37,@0x38,@0x34,@0x31,
                            @0x39,@0x37,@0x34,@0x34,
                            @0x31,@0x35,@0x30,@0x33,
                            @0x38,@0x33,@0x32,
                            @0xe1,@0x02,@0x00,@0x09,
                            @0x30,@0x30,@0x30,@0x30,
                            @0x31,@0x31,@0x35,@0x38,
                            @0x32,
                            @0x00,@0x00,@0x00];
    fileOne = [[EIDFileOne alloc] initWithBytes:fileOneBytes];
}

-(void)testKirilMilevCardCardId
{
    NSData *cardIdData = [eidParser dataForTag:fileOne.cardIdEidTlv.tag inFile:fileOne];
    NSString *parserCardNumber = [[NSString alloc] initWithData:cardIdData encoding:NSASCIIStringEncoding];
    XCTAssertEqual(kirilMilevCardNumber, parserCardNumber);
}

- (void)tearDown
{
    eidParser = nil;
    [super tearDown];
}

@end
