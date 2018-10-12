#import <Foundation/Foundation.h>

typedef enum {
    
    CardTypeNoCard = 0,
    CardTypeEMV,
    CardTypeEID,
    CardTypeUnsupported
    
} CardType;

typedef enum {
    
    ReaderDeviceTypeNotRecognized = 0,
    ReaderDeviceTypeTactivo,
    ReaderDeviceTypeFeitian,
    ReaderDeviceTypeNefcom
    
} ReaderDeviceType;

@protocol SmartEIDDelegate

-(void)didInsertCard;
-(void)didRemoveCard;

-(void)didConnectDeviceReader;
-(void)didDisonnectDeviceReader;

-(void)didReadPublicData:(id)publicData;
-(void)didFailReadPublicData:(NSError *)error;

@end

@interface SmartEID : NSObject

@property (weak, nonatomic) id <SmartEIDDelegate> delegate;

-(void)readPublicData;
-(CardType)currentCardType;

- (instancetype)initWithDelegate:(id <SmartEIDDelegate>)delegate;

@end
