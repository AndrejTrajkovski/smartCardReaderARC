//
//  CommandProcessor.h
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import <Foundation/Foundation.h>
#import "CardReaderCommandExecutioner.h"

@class CAPDU, RAPDU, PBSmartcard;

@interface PublicDataReader : NSObject

-(instancetype)initWithExecutioner:(id <CardReaderCommandExecutioner>)commandExecutioner;
@property (strong, nonatomic) id <CardReaderCommandExecutioner> commandExecutioner;

-(NSString *)readPublicDataViaPSEWithError:(NSError **)error;
//-(void)readPublicDataViaPPSE;
-(NSString *)readPublicDataForAID:(NSArray *)aid error:(NSError **)error;

@end
