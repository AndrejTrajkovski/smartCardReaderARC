//
//  RAPDU.h
//  SmartCardSampleOBJC1
//
//  Created by Andrej Trajkovski on 7/15/18.
//

#import "APDU.h"
#import "PBSmartcard.h"

@interface RAPDU : NSObject <APDU>

@property (assign, nonatomic) PBSmartcardStatus status;
-(instancetype)initWithResponseBytes:(unsigned char *)responseBytes
                           andLength:(int)length
                           andStatus:(PBSmartcardStatus)status;
@end
