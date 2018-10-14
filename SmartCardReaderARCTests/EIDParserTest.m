#import <XCTest/XCTest.h>
#import "EIDParser.h"
#import "EIDBerTags.h"

@interface EIDParserTest : XCTestCase

@end

@implementation EIDParserTest {
    EIDParser *eidParser;
    NSString *kirilMilevCardNumber;
    NSString *kirilMilevIdNumber;
    NSArray *kirilMilevCardFileOneBytes;
}

- (void)setUp
{
    [super setUp];
    eidParser = [EIDParser new];
    
    kirilMilevCardNumber = @"000011582";
    kirilMilevIdNumber = @"784197441503832";
    
    kirilMilevCardFileOneBytes = @[@0x70,@0x01,@0x00,@0x20,
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
}

-(void)testKirilMilevCardCardId
{
    NSData *cardIdData = [eidParser dataForTag:[EIDBerTags ID_NUMBER] inBytes:kirilMilevCardFileOneBytes];
    NSString *parserCardNumber = [[NSString alloc] initWithData:cardIdData encoding:NSASCIIStringEncoding];
    XCTAssertEqualObjects(kirilMilevIdNumber, parserCardNumber);
}

-(void)testKirilMilevCardCardNumber
{
    NSData *cardIdData = [eidParser dataForTag:[EIDBerTags CARD_NUMBER] inBytes:kirilMilevCardFileOneBytes];
    NSString *parserCardNumber = [[NSString alloc] initWithData:cardIdData encoding:NSASCIIStringEncoding];
    XCTAssertEqualObjects(kirilMilevCardNumber, parserCardNumber);
}

- (void)tearDown
{
    eidParser = nil;
    [super tearDown];
}

@end
