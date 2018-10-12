#import "RAPDU.h"
#import "NSArray+ByteManipulation.h"

@implementation RAPDU{
    
    NSArray *response;
}

-(instancetype)initWithResponseBytes:(unsigned char *)responseBytes
                           andLength:(int)length
{
    self = [super init];
    
    if (self) {
        
        response = [NSArray arrayWithUnsignedCharArray:responseBytes withCount:length];
    }
    
    return self;
}

-(NSArray *)bytes
{
    return response;
}

-(RAPDUStatus)responseStatus
{
    if (self.bytes.count > 1) {
        
        if ([[self byteBeforeLast] isEqual:@0x61]) {
            
            return RAPDUStatusResponseBytesStillAvailable;
            
        }else if ([[self byteBeforeLast] isEqual:@0x6C] || [[self byteBeforeLast] isEqual:@0x67]){
            
            return RAPDUStatusWrongLength;
            
        }else if ([[self byteBeforeLast] isEqual:@0x90] && [[self lastByte] isEqual:@0x00]){
            
            return RAPDUStatusSuccess;
        
        }else if ([[self byteBeforeLast] isEqual:@0x6B]){
            
            return RAPDUStatusWrongP1P2;
            
        }else{
            
            return RAPDUStatusOther;
        }
        
    }else{
        
        return RAPDUStatusNoBytes;
    }
}

-(NSNumber *)lastByte
{
    return self.bytes[self.bytes.count - 1];
}

-(NSNumber *)byteBeforeLast
{
    return self.bytes[self.bytes.count - 2];
}

-(NSArray *)bytesWithoutStatus
{
    NSRange cutLastTwoElementsRange = NSMakeRange(0, self.bytes.count - 2 );
    NSArray *bytesWithoutStatus = [self.bytes subarrayWithRange:cutLastTwoElementsRange];
    return bytesWithoutStatus;
}

@end
