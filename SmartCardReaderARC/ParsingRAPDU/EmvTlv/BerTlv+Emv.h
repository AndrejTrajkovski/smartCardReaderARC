//
//  BerTlv+Emv.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/27/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "BerTlv.h"

@interface BerTlv (Emv)

- (NSString *)emvDump:(NSString *)aPadding ;

@end
