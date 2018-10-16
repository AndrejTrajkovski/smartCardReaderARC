#import "ViewController.h"
#import "SmartEID.h"
//#import "lbrReader.h"
#import "EIDCardModel.h"

@interface ViewController () <SmartEIDDelegate>

@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (weak, nonatomic) IBOutlet UIImageView *facialImageView;
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
    if ([publicData isKindOfClass:[EIDCardModel class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.facialImageView.image = [(EIDCardModel *)publicData facialImage];
        });
    }
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
