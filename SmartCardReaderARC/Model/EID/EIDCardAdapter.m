
#import "EIDCardAdapter.h"
#import <UIKit/UIImage.h>
#import "EIDCardModel.h"
#import "EIDFiles.h"
#import "EIDParser.h"
#import "EIDBerTags.h"
#import "BerTag.h"
#import "NSArray+ByteManipulation.h"

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
        
        if ([file isKindOfClass:[EIDFile0201 class]]) {
            NSData *cardNumberData = [self.parser dataForTag:[EIDBerTags CARD_NUMBER] inFile:file];
            card.cardNumber = [self stringForData:cardNumberData];
            
            NSData *cardIdData = [self.parser dataForTag:[EIDBerTags ID_NUMBER] inFile:file];
            card.cardId = [self stringForData:cardIdData];
        }else if ([file isKindOfClass:[EIDFile0202 class]]){
            NSData *facialImageData = [self.parser dataForTag:[EIDBerTags FACIAL_IMAGE] inFile:file];
            card.facialImage = [self imageForData:facialImageData];
        }else if ([file isKindOfClass:[EIDFile0203 class]]){
            NSData *idtypeData = [self.parser dataForTag:[EIDBerTags ID_TYPE] inFile:file];
            card.idType = [self stringForData:idtypeData];
            
            NSData *cardIssuedDateData = [self.parser dataForTag:[EIDBerTags CARD_ISSUE_DATE] inFile:file];
            card.cardIssueDate = [self dateStringForData:cardIssuedDateData];
            
            NSData *cardExpiryDateData = [self.parser dataForTag:[EIDBerTags CARD_EXPIRY_DATE] inFile:file];
            card.cardExpiryDate = [self dateStringForData:cardExpiryDateData];

            NSData *arabicTitle = [self.parser dataForTag:[EIDBerTags ARABIC_TITLE] inFile:file];
            card.arabicTitle = [self stringForData:arabicTitle];

            NSData *englishTitle = [self.parser dataForTag:[EIDBerTags ENGLISH_TITLE] inFile:file];
            card.englishTitle = [self stringForData:englishTitle];
            
            NSData *englishFullName = [self.parser dataForTag:[EIDBerTags ENGLISH_FULL_NAME] inFile:file];
            card.englishFullName = [self stringForData:englishFullName];
            
            NSData *genderCode = [self.parser dataForTag:[EIDBerTags GENDER_CODE] inFile:file];
            card.gender = [self stringForData:genderCode];
            
            NSData *arabicNationalityCode = [self.parser dataForTag:[EIDBerTags ARABIC_NATIONALITY_CODE] inFile:file];
            card.arabicNationalityCode = [self stringForData:arabicNationalityCode];
            
            NSData *englishNationalityCode = [self.parser dataForTag:[EIDBerTags ENGLISH_NATIONALITY_CODE] inFile:file];
            card.englishNationalityCode = [self stringForData:englishNationalityCode];
            
            NSData *englishNationality = [self.parser dataForTag:[EIDBerTags ENGLISH_NATIONALITY] inFile:file];
            card.englishNationality = [self stringForData:englishNationality];

            NSData *dateOfBirth = [self.parser dataForTag:[EIDBerTags DATE_OF_BIRTH] inFile:file];
            card.dateOfBirth = [self dateStringForData:dateOfBirth];
            
            NSData *arabicMotherFirstName = [self.parser dataForTag:[EIDBerTags ARABIC_MOTHER_FIRST_NAME] inFile:file];
            card.arabicMotherFirstName = [self stringForData:arabicMotherFirstName];
            
            NSData *englishMotherFirstName = [self.parser dataForTag:[EIDBerTags ENGLISH_MOTHER_FIRST_NAME] inFile:file];
            card.englishMotherFirstName = [self stringForData:englishMotherFirstName];
            
            NSData *placeOfBirth = [self.parser dataForTag:[EIDBerTags PLACE_OF_BIRTH] inFile:file];
            card.placeOfBirth = [self stringForData:placeOfBirth];
            
            NSData *arabicPlaceOfBirth = [self.parser dataForTag:[EIDBerTags ARABIC_PLACE_OF_BIRTH] inFile:file];
            card.arabicPlaceOfBirth = [self stringForData:arabicPlaceOfBirth];
            
        }else if ([file isKindOfClass:[EIDFile0205 class]]){
            
            NSData *occupationCode = [self.parser dataForTag:[EIDBerTags OCCUPATION_CODE] inFile:file];
            card.occupationCode = [self stringForData:occupationCode];
            
            NSData *maritialStatusCode = [self.parser dataForTag:[EIDBerTags MARITIAL_STATUS_CODE] inFile:file];
            card.maritialStatusCode = [self stringForData:maritialStatusCode];
            
            NSData *husbandIdn = [self.parser dataForTag:[EIDBerTags HUSBAND_IDN] inFile:file];
            card.husbandIdn = [self stringForData:husbandIdn];
            
            NSData *sponsorType = [self.parser dataForTag:[EIDBerTags SPONSOR_TYPE] inFile:file];
            card.sponsorType = [self stringForData:sponsorType];
            
            NSData *sponsorNumber = [self.parser dataForTag:[EIDBerTags SPONSOR_NUMBER] inFile:file];
            card.sponsorNumber = [self stringForData:sponsorNumber];
            
            NSData *sponsorNameEnglish = [self.parser dataForTag:[EIDBerTags SPONSOR_NAME_ENGLISH] inFile:file];
            card.sponsorNameEnglish = [self stringForData:sponsorNameEnglish];
            
            NSData *sponsorNameArabic = [self.parser dataForTag:[EIDBerTags SPONSOR_NAME_ARABIC] inFile:file];
            card.sponsorNameArabic = [self stringForData:sponsorNameArabic];
            
            NSData *residencyType = [self.parser dataForTag:[EIDBerTags RESIDENCY_TYPE] inFile:file];
            card.residencyType = [self stringForData:residencyType];
            
            NSData *residencyNumber = [self.parser dataForTag:[EIDBerTags RESIDENCY_NUMBER] inFile:file];
            card.residencyNumber = [self stringForData:residencyNumber];
            
            NSData *residencyExpiryDate = [self.parser dataForTag:[EIDBerTags RESIDENCY_EXPIRY_DATE] inFile:file];
            card.residencyExpiryDate = [self dateStringForData:residencyExpiryDate];
            
            NSData *familyId = [self.parser dataForTag:[EIDBerTags FAMILY_ID] inFile:file];
            card.familyId = [self stringForData:familyId];
            
            NSData *passportNumber = [self.parser dataForTag:[EIDBerTags PASSPORT_NUMBER] inFile:file];
            card.passportNumber = [self stringForData:passportNumber];
            
            NSData *passportCountryArabic = [self.parser dataForTag:[EIDBerTags PASSPORT_COUNTRY_ARABIC] inFile:file];
            card.passportCountryArabic = [self stringForData:passportCountryArabic];
            
            NSData *passportCountryEnglish = [self.parser dataForTag:[EIDBerTags PASSPORT_COUNTRY_ENGLISH] inFile:file];
            card.passportCountryEnglish = [self stringForData:passportCountryEnglish];
            
            NSData *passportCountryCodeEnglish = [self.parser dataForTag:[EIDBerTags PASSPORT_COUNTRY_CODE_ENGLISH] inFile:file];
            card.passportCountryCodeEnglish = [self stringForData:passportCountryCodeEnglish];
            
            NSData *passportIssueDate = [self.parser dataForTag:[EIDBerTags PASSPORT_ISSUE_DATE] inFile:file];
            card.passportIssueDate = [self dateStringForData:passportIssueDate];
            
            NSData *passportExpiryDate = [self.parser dataForTag:[EIDBerTags PASSPORT_EXPIRY_DATE] inFile:file];
            card.passportExpiryDate = [self dateStringForData:passportExpiryDate];
            
            NSData *qualificationLevelDescriptionArabic = [self.parser dataForTag:[EIDBerTags QUALIFICATION_LEVEL_DESCRIPTION_ARABIC] inFile:file];
            card.qualificationLevelDescriptionArabic = [self stringForData:qualificationLevelDescriptionArabic];
            
            NSData *qualificationLevelDescriptionEnglish = [self.parser dataForTag:[EIDBerTags QUALIFICATION_LEVEL_DESCRIPTION_ENGLISH] inFile:file];
            card.qualificationLevelDescriptionEnglish = [self stringForData:qualificationLevelDescriptionEnglish];
            
            NSData *degreeDescriptionArabic = [self.parser dataForTag:[EIDBerTags DEGREE_DESCRIPTION_ARABIC] inFile:file];
            card.degreeDescriptionArabic = [self stringForData:degreeDescriptionArabic];
            
            NSData *degreeDescriptionEnglish = [self.parser dataForTag:[EIDBerTags DEGREE_DESCRIPTION_ENGLISH] inFile:file];
            card.degreeDescriptionEnglish = [self stringForData:degreeDescriptionEnglish];
            
            NSData *fieldOfStudyArabic = [self.parser dataForTag:[EIDBerTags FIELD_OF_STUDY_ARABIC] inFile:file];
            card.fieldOfStudyArabic = [self stringForData:fieldOfStudyArabic];
            
            NSData *fieldOfStudyEnglish = [self.parser dataForTag:[EIDBerTags FIELD_OF_STUDY_ENGLISH] inFile:file];
            card.fieldOfStudyEnglish = [self stringForData:fieldOfStudyEnglish];
            
            NSData *occupationArabic = [self.parser dataForTag:[EIDBerTags OCCUPATION_ARABIC] inFile:file];
            card.occupationArabic = [self stringForData:occupationArabic];
            
            NSData *occupationEnglish = [self.parser dataForTag:[EIDBerTags OCCUPATION_ENGLISH] inFile:file];
            card.occupationEnglish = [self stringForData:occupationEnglish];
            
            NSData *occupationTypeArabic = [self.parser dataForTag:[EIDBerTags OCCUPATION_TYPE_ARABIC] inFile:file];
            card.occupationTypeArabic = [self stringForData:occupationTypeArabic];
            
            NSData *occupationTypeEnglish = [self.parser dataForTag:[EIDBerTags OCCUPATION_TYPE_ENGLISH] inFile:file];
            card.occupationTypeEnglish = [self stringForData:occupationTypeEnglish];
            
            NSData *companyNameArabic = [self.parser dataForTag:[EIDBerTags COMPANY_NAME_ARABIC] inFile:file];
            card.companyNameArabic = [self stringForData:companyNameArabic];
            
            NSData *companyNameEnglish = [self.parser dataForTag:[EIDBerTags COMPANY_NAME_ENGLISH] inFile:file];
            card.companyNameEnglish = [self stringForData:companyNameEnglish];
            
            NSData *motherFullNameArabic = [self.parser dataForTag:[EIDBerTags MOTHER_FULL_NAME_ARABIC] inFile:file];
            card.motherFullNameArabic = [self stringForData:motherFullNameArabic];
            
            NSData *motherFullNameEnglish = [self.parser dataForTag:[EIDBerTags MOTHER_FULL_NAME_ENGLISH] inFile:file];
            card.motherFullNameEnglish = [self stringForData:motherFullNameEnglish];
            //////////////////file A02
        }else if ([file isKindOfClass:[EIDFile0A02 class]]){

            NSData *emirateDescriptionEnglish = [self.parser dataForTag:[EIDBerTags EMIRATE_DESCRIPTION_ENGLISH] inFile:file];
            card.emirateDescriptionEnglish = [self stringForData:emirateDescriptionEnglish];
            
            NSData *emirateDescriptionArabic = [self.parser dataForTag:[EIDBerTags EMIRATE_DESCRIPTION_ARABIC] inFile:file];
            card.emirateDescriptionArabic = [self stringForData:emirateDescriptionArabic];
            
            NSData *cityDescriptionEnglish = [self.parser dataForTag:[EIDBerTags CITY_DESCRIPTION_ENGLISH] inFile:file];
            card.cityDescriptionEnglish = [self stringForData:cityDescriptionEnglish];
            
            NSData *cityDescriptionArabic = [self.parser dataForTag:[EIDBerTags CITY_DESCRIPTION_ARABIC] inFile:file];
            card.cityDescriptionArabic = [self stringForData:cityDescriptionArabic];
            
            NSData *streetDescriptionEnglish = [self.parser dataForTag:[EIDBerTags STREET_DESCRIPTION_ENGLISH] inFile:file];
            card.streetDescriptionEnglish = [self stringForData:streetDescriptionEnglish];
            
            NSData *streetDescriptionArabic = [self.parser dataForTag:[EIDBerTags STREET_DESCRIPTION_ARABIC] inFile:file];
            card.streetDescriptionArabic = [self stringForData:streetDescriptionArabic];
            
            NSData *areaDescriptionEnglish = [self.parser dataForTag:[EIDBerTags AREA_DESCRIPTION_ENGLISH] inFile:file];
            card.areaDescriptionEnglish = [self stringForData:areaDescriptionEnglish];
            
            NSData *areaDescriptionArabic = [self.parser dataForTag:[EIDBerTags AREA_DESCRIPTION_ARABIC] inFile:file];
            card.areaDescriptionArabic = [self stringForData:areaDescriptionArabic];
            
            NSData *buildingDescriptionEnglish = [self.parser dataForTag:[EIDBerTags BUILDING_DESCRIPTION_ENGLISH] inFile:file];
            card.buildingDescriptionEnglish = [self stringForData:buildingDescriptionEnglish];

            NSData *phone = [self.parser dataForTag:[EIDBerTags PHONE] inFile:file];
            card.phone = [self stringForData:phone];
            
            NSData *mobile = [self.parser dataForTag:[EIDBerTags MOBILE] inFile:file];
            card.mobile = [self stringForData:mobile];
            
            NSData *poBox = [self.parser dataForTag:[EIDBerTags PO_BOX] inFile:file];
            card.poBox = [self stringForData:poBox];
            
        }else if ([file isKindOfClass:[EIDFile0207 class]]){

            NSData *signatureImage = [self.parser dataForTag:[EIDBerTags SIGNATURE_IMAGE] inFile:file];
            card.signatureImage = [self imageForData:signatureImage];
        }
    }];
    return card;
}

-(NSString *)dateStringForData:(NSData *)data
{
    NSArray *byteArray = [NSArray byteArrayFromData:data];
    NSMutableString *dateString = [NSMutableString new];
    if (byteArray.count > 3) {
        NSUInteger dayByte = [(NSNumber *)[byteArray objectAtIndex:3] unsignedIntegerValue];
        NSUInteger monthByte = [(NSNumber *)[byteArray objectAtIndex:2] unsignedIntegerValue];
        NSUInteger firstPartOfYearByte = [(NSNumber *)[byteArray objectAtIndex:0] unsignedIntegerValue];
        NSUInteger secondPartOfYearByte = [(NSNumber *)[byteArray objectAtIndex:1] unsignedIntegerValue];
        [dateString appendFormat:@"%02lX", (unsigned long)dayByte];
        [dateString appendFormat:@"/"];
        [dateString appendFormat:@"%02lX", (unsigned long)monthByte];
        [dateString appendFormat:@"/"];
        [dateString appendFormat:@"%02lX", (unsigned long)firstPartOfYearByte];
        [dateString appendFormat:@"%02lX", (unsigned long)secondPartOfYearByte];
    }
    return dateString;
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
