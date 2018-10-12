//
//  EIDFileOne.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/11/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "EIDBaseFile.h"
@class EIDTlv;

@interface EIDFileOne : EIDBaseFile <EIDFileTags>

- (EIDTlv *)cardNumberEidTlv;

@end
