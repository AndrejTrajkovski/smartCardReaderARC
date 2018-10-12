#import "BerTlv+Emv.h"
#import "BerTag.h"
#import "EmvTlvList.h"
#import "EMVTlv.h"

@implementation BerTlv (Emv)

- (NSString *)emvDump:(NSString *)aPadding {
    NSMutableString *sb = [[NSMutableString alloc] init];
    
    NSError *error = nil;
    EMVTlv *myEmv = [EmvTlvList emvTlvWithTag:self.tag error:&error];
    
    NSString *valueString;
    NSString *tagName;

    //FIXME: Parsing for each type
    if (!myEmv) {
        valueString = error.localizedDescription;
        tagName = self.tag.hex;
    }else {
        switch (myEmv.type) {
            case Text:
                    valueString = self.textValue;
                break;
            case Numeric:
                    valueString = self.hexValue;
                break;
            default:
                    valueString = self.hexValue;
                break;
        }
        tagName = myEmv.name;
    }
    
    if(self.primitive) {
        [sb appendFormat:@"%@ - [%@] %@\n", aPadding, tagName, valueString];
    } else {
        [sb appendFormat:@"%@ + [%@]\n", aPadding, tagName];
        NSMutableString *childPadding = [[NSMutableString alloc] init];
        [childPadding appendString:aPadding];
        [childPadding appendString:aPadding];
        for (BerTlv *tlv in self.list) {
            [sb appendString:[tlv emvDump:childPadding]];
        }
    }
    return sb;
}

- (NSString *)binaryValue {
    return [[NSString alloc] initWithData:self.value encoding:NSUTF8StringEncoding];
}

@end
