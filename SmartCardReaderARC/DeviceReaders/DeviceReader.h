#import <Foundation/Foundation.h>

@class CAPDU, RAPDU, PBSmartcard;

@protocol DeviceReaderDelegate <NSObject>

-(void)didPrepareCardSuccessfully;

-(void)didFailPrepareCardWithError:(NSError *)error;

-(void)didFinalizeCardSuccessfully;

-(void)didFailFinalizeCardWithError:(NSError *)error;

@end

@protocol DeviceReader <NSObject>

@property (weak) id<DeviceReaderDelegate> delegate;

-(void)prepareCard;

-(RAPDU *)executeCommand:(CAPDU *)capdu error:(NSError **)error;

-(void)finalizeCard;

@end
