//
//  CommandProcessor.h
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import <Foundation/Foundation.h>

@class CAPDU, RAPDU, PBSmartcard;

@interface CommandProcessor : NSObject

//-(RAPDU*)executeCommand:(CAPDU *)capdu;
-(void)start;
@property (strong, nonatomic) PBSmartcard *smartCard;

-(instancetype)initWithCommandFlow:(NSArray *)commands andSmartCard:(PBSmartcard *)smardCard;

@end
