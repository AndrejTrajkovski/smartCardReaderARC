#import <Foundation/Foundation.h>
#import "DeviceReader.h"

@protocol PDReaderDelegate <NSObject>

-(void)didReadPublicData:(id)publicDataRecords;
-(void)didFailToReadPublicDataWithError:(NSError *)error;

@end

extern NSString * const ReadingPublicDataErrorDomain;

typedef NS_ENUM(NSInteger, ReadingPublicDataErrorCode) {
    ReadingPublicDataErrorCodeWhenPreparingCard = 1,
    ReadingPublicDataErrorCodePDOLRequired = 2,
    ReadingPublicDataErrorCodeNoPSEDir = 3,
    ReadingPublicDataErrorCodeNoPPSEDir = 4,
    ReadingPublicDataErrorCodeSelectAID
    
};

@protocol PDReader <NSObject>


@property (weak) id <PDReaderDelegate> delegate;
@property (strong, nonatomic) id <DeviceReader> deviceReader;

-(instancetype)initWithDeviceReader:(id<DeviceReader>)deviceReader
                        andDelegate:(id <PDReaderDelegate>)delegate;
-(void)readPublicData;

@end
