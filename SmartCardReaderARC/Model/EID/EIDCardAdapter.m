
#import "EIDCardAdapter.h"
#import <UIKit/UIImage.h>
#import "EIDCardModel.h"
#import "EIDFiles.h"
#import "EIDParser.h"
#import "EIDBerTags.h"
#import "BerTag.h"

@interface EIDCardAdapter()

@property (nonatomic, strong) EIDParser *parser;

@end

@implementation EIDCardAdapter

-(instancetype)initWithParser:(EIDParser *)parser
{
    self = [super init];
    
    if (self) {
        self.parser = parser;
    }
    
    return self;
}

-(EIDCardModel *)cardModelForFiles:(NSArray *)files
{
    __block EIDCardModel *card = [EIDCardModel new];
    [files enumerateObjectsUsingBlock:^(EIDBaseFile *file, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([file isKindOfClass:[EIDFileOne class]]) {
            BerTag *cardNumberTag = [EIDBerTags CARD_NUMBER];
            NSData *cardNumberData = [self.parser dataForTag:cardNumberTag inFile:file];
            card.cardNumber = [self stringForData:cardNumberData];

            BerTag *cardIdInfo = [EIDBerTags ID_NUMBER];
            NSData *cardIdData = [self.parser dataForTag:cardIdInfo inFile:file];
            card.cardId = [self stringForData:cardIdData];
        }else if ([file isKindOfClass:[EIDFileTwo class]]){
            BerTag *imageTag = [EIDBerTags FACIAL_IMAGE];
            NSData *facialImageData = [self.parser dataForTag:imageTag inFile:file];
            card.facialImage = [self imageForData:facialImageData];
        }else if ([file isKindOfClass:[EIDFileThree class]]){

            BerTag *idTypeTag = [EIDBerTags ID_TYPE];
            NSData *idtypeData = [self.parser dataForTag:idTypeTag inFile:file];
            card.idType = [self stringForData:idtypeData];
//            // EF 0x0203
//        case ef0203_ID_Type = 0xE305
//        case ef0203_Card_Issue_Date = 0x4306
//        case ef0203_Card_Expiry_Date = 0x4307
//        case ef0203_Arabic_Title = 0xA308
//        case ef0203_Arabic_Full_Name = 0xA309
//        case ef0203_English_Title = 0xE30A
//        case ef0203_English_Full_Name = 0xE30B
//        case ef0203_Gender_Code = 0xE30C
//        case ef0203_Arabic_Nationality_Code = 0xA30D
//        case ef0203_English_Nationality_Code = 0xE30E
//        case ef0203_English_Nationality = 0xE336
//        case ef0203_Date_of_Birth = 0x430F
//        case ef0203_Arabic_Mother_First_Name = 0xA310
//        case ef0203_English_Mother_First_Name = 0xE311
//
//        case ef0203_V2_Place_Of_Birth = 0xE338
//        case ef0203_V2_Arabic_Place_Of_Birth = 0xA337

        }
        
    }];
    return card;
}

-(NSString *)stringForData:(NSData *)data
{
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    return value;
}

-(NSNumber *)numberForData:(NSData *)data
{
    NSInteger decodedInteger;
    [data getBytes:&decodedInteger length:sizeof(decodedInteger)];
    NSNumber *integerObject = [NSNumber numberWithInteger:decodedInteger];
    return integerObject;
}

-(UIImage *)imageForData:(NSData *)data
{
    UIImage *myImage = [[UIImage alloc] initWithData:data];
    return myImage;
}

@end
