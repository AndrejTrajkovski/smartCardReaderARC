//
//  FeitianDeviceReader.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 9/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "FeitianDeviceReader.h"
#import "ft301u.h"
#import "ReaderInterface.h"
#import "CAPDU.h"
#import "RAPDU.h"
#import "NSArray+ByteManipulation.h"

SCARDCONTEXT gContxtHandle;

@interface FeitianDeviceReader() <ReaderInterfaceDelegate>

@property (strong, nonatomic) ReaderInterface *interface;

@end

@implementation FeitianDeviceReader{
    SCARDHANDLE  gCardHandle;
}

@synthesize delegate;

- (RAPDU *)executeCommand:(CAPDU *)capdu error:(NSError *__autoreleasing *)error {
    
    unsigned char buffer[255] = {0};
    unsigned char *command = [capdu.bytes cArrayFromBytes];
    unsigned int rdl;
    rdl = sizeof(buffer);

    SCARD_IO_REQUEST pioSendPci;
    int status = SCardTransmit(gContxtHandle,
                               &pioSendPci,
                               command,
                               (u_int32_t)capdu.bytes.count,
                               NULL,
                               buffer,
                               &rdl);
    
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
                *error = [NSError errorWithDomain:@"Feitian Reader Error" code:200 userInfo:details];
            }

            return nil;
        }

        return responseAPDU;

    }else{

        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Command not sent" forKey:NSLocalizedDescriptionKey];
        if (error) {
            *error = [NSError errorWithDomain:@"Feitian Reader Error" code:200 userInfo:details];
        }

        return nil;
    }
}

- (void)finalizeCard {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        SCardDisconnect(self->gCardHandle, SCARD_UNPOWER_CARD);
    });
}

- (void)prepareCard {
    
    [DeviceType setDeviceType:IR301_AND_BR301];
    self.interface = [ReaderInterface new];
    [self.interface setDelegate:self];
    
    NSInteger ret = SCardEstablishContext(SCARD_SCOPE_SYSTEM,NULL,NULL,&gContxtHandle);
    if(ret != 0){
        [self.delegate didFailPrepareCardWithError:nil];
        return;
    }

    BOOL readerAttached = [self.interface isReaderAttached];
    BOOL cardAttached = [self.interface isCardAttached];
    char mszReaders[128] = "";
    DWORD pcchReaders = -1;
    NSInteger iRet = SCardListReaders(gContxtHandle, NULL, mszReaders, &pcchReaders);

    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        DWORD dwActiveProtocol = -1;
        NSString *deviceName = @"FT smartcard reader";
        NSInteger retBlock = SCardConnect(gContxtHandle, [deviceName UTF8String], SCARD_SHARE_SHARED,SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1, &gCardHandle, &dwActiveProtocol);
        
        if(retBlock != 0){
            
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            NSString *errorMsg = [NSString stringWithFormat:@"connect device error: %08lx",(long)retBlock];
            [details setValue:errorMsg forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"Feitian Reader Error" code:200 userInfo:details];
            [self.delegate didFailPrepareCardWithError:error];
            
            return;
        }
        
        [self.delegate didPrepareCardSuccessfully];
//    });
}

#pragma mark ReaderInterfaceDelegate

- (void)cardInterfaceDidDetach:(BOOL)attached {

}

- (void)findPeripheralReader:(NSString *)readerName {

}

- (void)readerInterfaceDidChange:(BOOL)attached {

}

@end
