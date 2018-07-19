//
//  TactivoExecutioner.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/18/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "TactivoExecutioner.h"
#import "PBSmartcard.h"
#import "CardReaderCommandExecutioner.h"
#import "CAPDU.h"
#import "RAPDU.h"
#import "NSArray+ByteManipulation.h"

@interface TactivoExecutioner()

@end

@implementation TactivoExecutioner

-(BOOL)prepareCard:(NSError **)error
{
    self.smartCard = [[PBSmartcard alloc] init];
    PBSmartcardStatus status;
    
    status = [self.smartCard open];
    status = [self.smartCard connect:PBSmartcardProtocolTx];
    
    if (status != PBSmartcardStatusSuccess) {
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[PBSmartcard stringFromStatus:status] forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:@"Tactivo Reader Error" code:200 userInfo:details];
        }
        
        return NO;
    }
    
    return YES;
}

-(RAPDU *)executeCommand:(CAPDU *)capdu error:(NSError **)error
{
    unsigned char buffer[255] = {0};
    unsigned char *command = [capdu.bytes cArrayFromBytes];
    unsigned short rdl;
    rdl = sizeof(buffer);
    
    PBSmartcardStatus status = [self.smartCard transmit:command
                                      withCommandLength:capdu.bytes.count
                                      andResponseBuffer:buffer
                                      andResponseLength:&rdl];
    int responseLength = (int)rdl;
    
    if (status != PBSmartcardStatusSuccess) {
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[PBSmartcard stringFromStatus:status] forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:@"Tactivo Reader Error" code:200 userInfo:details];
        }
        
        return nil;
    }
    
    RAPDU *responseAPDU = [[RAPDU alloc] initWithResponseBytes:buffer
                                                     andLength:responseLength
                                                     andStatus:status];
    
    return responseAPDU;
}

@end
