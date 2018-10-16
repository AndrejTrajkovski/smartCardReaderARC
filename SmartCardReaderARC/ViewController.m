#import "ViewController.h"
#import "SmartEID.h"
//#import "lbrReader.h"
#import "EIDCardModel.h"

@interface ViewController () <SmartEIDDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *signatureImageView;
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
            EIDCardModel *eidCard = (EIDCardModel *)publicData;
            self.facialImageView.image = [eidCard facialImage];
            self.signatureImageView.image = [eidCard signatureImage];
            for (NSString *str in [eidCard cardDesription]) {
                if ([str isKindOfClass:[NSString class]]){
                    self.statusTextView.text = [self.statusTextView.text stringByAppendingString:str];
                }
            }
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
