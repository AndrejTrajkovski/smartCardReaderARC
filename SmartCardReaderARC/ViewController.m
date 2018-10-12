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
#import "EIDCardModel.h"

@interface ViewController () <SmartEIDDelegate>

@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (strong, nonatomic) SmartEID *smartEid;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.smartEid = [[SmartEID alloc] initWithDelegate:self];
    [self.smartEid readPublicData];
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
