//
//  GetResponseCAPDU.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 7/15/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import "CAPDU.h"

@interface GetResponseCAPDU : CAPDU

-(instancetype)initWithExpectedLength:(Byte)le;

@end
