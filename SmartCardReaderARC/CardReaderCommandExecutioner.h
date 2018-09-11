//
//  CardReaderCommandExecutioner.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/18/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CAPDU, RAPDU, PBSmartcard;
@protocol CardReaderCommandExecutioner <NSObject>

-(RAPDU *)executeCommand:(CAPDU *)capdu error:(NSError **)error;
-(BOOL)prepareCard:(NSError **)error;

@end
