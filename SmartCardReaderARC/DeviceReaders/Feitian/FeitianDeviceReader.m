//
//  FeitianDeviceReader.m
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 9/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "FeitianDeviceReader.h"
//#import "ft301u.h"
//#import "ReaderInterface.h"
//#import "winscard.h"

@interface FeitianDeviceReader()//<ReaderInterfaceDelegate>

@end

@implementation FeitianDeviceReader{
//    SCARDHANDLE  gCardHandle;
//    ReaderInterface *interface;
}

@synthesize delegate;

- (RAPDU *)executeCommand:(CAPDU *)capdu error:(NSError *__autoreleasing *)error {
    //TODO
    return nil;
}

- (void)finalizeCard {
    //TODO
}

- (void)prepareCard {
    //TODO
//    interface = [ReaderInterface new];
//    [interface setDelegate:self];

}

#pragma mark ReaderInterfaceDelegate

- (void)cardInterfaceDidDetach:(BOOL)attached {
    
}

- (void)findPeripheralReader:(NSString *)readerName {
    
}

- (void)readerInterfaceDidChange:(BOOL)attached {
    
}

@end
