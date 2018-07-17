//
//  CommandProcessor.h
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import <Foundation/Foundation.h>

@class CAPDU, RAPDU, PBSmartcard;

@interface PublicDataReader : NSObject

@property (strong, nonatomic) PBSmartcard *smartCard;
-(instancetype)initWithSmartCard:(PBSmartcard *)smardCard;

-(void)selectPSEDir;
-(void)selectPPSEDir;
-(void)selectAID;

@end
