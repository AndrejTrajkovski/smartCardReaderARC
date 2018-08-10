//
//  CommandProcessor.h
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import <Foundation/Foundation.h>
#import "CardReaderCommandExecutioner.h"

@class CAPDU, RAPDU, PBSmartcard;

extern NSString * const ReadingPublicDataErrorDomain;

typedef NS_ENUM(NSInteger, ReadingPublicDataErrorCode) {
    ReadingPublicDataErrorCodePDOLRequired = 1,
    ReadingPublicDataErrorCodeNoPSEDir = 2,
    ReadingPublicDataErrorCodeNoPPSEDir = 3,
    ReadingPublicDataErrorCodeSelectAID
    
};

@interface PublicDataReader : NSObject

-(instancetype)initWithExecutioner:(id <CardReaderCommandExecutioner>)commandExecutioner;
@property (strong, nonatomic) id <CardReaderCommandExecutioner> commandExecutioner;

-(NSString *)readPublicDataViaPSEWithError:(NSError **)error;
-(NSString *)readPublicDataViaPPSEWithError:(NSError **)error;
-(NSString *)readPublicDataForAID:(NSArray *)aid error:(NSError **)error;

@end
