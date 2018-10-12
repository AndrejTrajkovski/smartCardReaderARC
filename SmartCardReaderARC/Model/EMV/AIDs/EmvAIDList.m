#import "EmvAIDList.h"
#import "CardAID.h"
#import "CHCSVParser.h"

static NSArray *list = nil;

@implementation EmvAIDList

+ (NSArray *)list
{
    if (!list) {
        
        list = [EmvAIDList getAidListFromResourceFileError:nil];
    }
    
    return list;
}

+(NSArray *)getAidListFromResourceFileError:(NSError **)error
{
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"AIDList" withExtension:@"csv"];
    NSArray *csvArray = [NSArray arrayWithContentsOfCSVURL:path];
    
    if (csvArray && csvArray.count > 1) {
        //cut first row(column titles)
        csvArray = [csvArray subarrayWithRange:NSMakeRange(1, csvArray.count - 1)];
        
        NSMutableArray *helperList = [NSMutableArray new];
        for (NSUInteger i = 0; i < csvArray.count; i++) {
            CardAID *oneAid = [[CardAID alloc] initFromCSVArray:csvArray[i]];
            [helperList addObject:oneAid];
        }
        
        return helperList;
    }
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:@"No AID CSV list file" forKey:NSLocalizedDescriptionKey];
    *error = [NSError errorWithDomain:@"Error parsing emv tags."
                                 code:201
                             userInfo:details];

    return nil;
}

@end
