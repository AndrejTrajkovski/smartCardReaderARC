//
//  NefcomExecutioner.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 9/10/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "NefcomExecutioner.h"
#import "NSArray+ByteManipulation.h"
#import "CAPDU.h"
#import "RAPDU.h"

@interface NefcomExecutioner()

@end

@implementation NefcomExecutioner

#pragma mark = CardReaderCommandExecutioner

- (BOOL)prepareCard:(NSError *__autoreleasing *)error
{
    int status = LTERR;
    int cardStatus = SC_CARD_ABSENT;
    
    status = [self.reader ConfigReader];
    if(status != LT_OK) {
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Config Reader Failed" forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:@"Nefcom Reader Error" code:200 userInfo:details];
        }
        
        return NO;
    }
    
    status = [self.reader GetCardStatus :&cardStatus];
    if(status == LT_OK)
    {
        if(cardStatus == SC_CARD_ABSENT) {
            
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"No Card!" forKey:NSLocalizedDescriptionKey];
            if (error) {
                *error = [NSError errorWithDomain:@"Nefcom Reader Error" code:200 userInfo:details];
            }
            
            return NO;
        }
    }
    
    status = [self.reader ConnectSCCard];
    if(status != LT_OK) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Connect Card Failed" forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:@"Nefcom Reader Error" code:200 userInfo:details];
        }
        
        return NO;
    }
    else {
        
        return YES;
    }
    
}

- (RAPDU *)executeCommand:(CAPDU *)capdu error:(NSError *__autoreleasing *)error
{
    
    unsigned char buffer[255] = {0};
    unsigned char *command = [capdu.bytes cArrayFromBytes];
    unsigned int rdl;
    rdl = sizeof(buffer);

    int status = [self.reader SCTransmit :command
                                         :capdu.bytes.count
                                         :buffer
                                         :&rdl];
    
    int responseLength = (int)rdl;

    if(status == 0)
    {
        RAPDU *responseAPDU = [[RAPDU alloc] initWithResponseBytes:buffer
                                                         andLength:responseLength];
        
        if (responseAPDU.responseStatus == RAPDUStatusOther) {
            
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:[NSString stringWithFormat:@"ERROR FOR CAPDU: %@.\nRAPDU STATUS BYTES: %c %c", capdu.bytes, responseAPDU.byteBeforeLast.unsignedShortValue, responseAPDU.lastByte.unsignedShortValue] forKey:NSLocalizedDescriptionKey];
            if (error) {
                *error = [NSError errorWithDomain:@"Error Reading From Card" code:200 userInfo:details];
            }
            
            return nil;
            
        }else if (responseAPDU.responseStatus == RAPDUStatusNoBytes) {
            
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"" forKey:NSLocalizedDescriptionKey];
            if (error) {
                *error = [NSError errorWithDomain:@"Nefcom Reader Error" code:200 userInfo:details];
            }
            
            return nil;
        }
        
        return responseAPDU;
        
    }else{
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Command not sent" forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:@"Nefcom Reader Error" code:200 userInfo:details];
        }
        
        return nil;
    }
}

//#pragma mark - lbrReaderDelegate
//
//- (void)didConnectLBRReader:(int *)iConnectionStatus
//{
//
//}
//
//- (void)didConnectCLSReader:(int *)iConnectionStatus
//{
//    //do nothing
//}
//
//- (void)EnrollImageCallBack:(UIImage *)image
//{
//    //do nothing
//}

@end
