#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface EIDCardModel : NSObject

@property (strong, nonatomic) NSString *cardId;
@property (strong, nonatomic) NSString *cardNumber; 
@property (strong, nonatomic) NSString *idType;

@property (strong, nonatomic) UIImage *facialImage;

@property (strong, nonatomic) NSString *cardIssueDate;
@property (strong, nonatomic) NSString *cardExpiryDate;
@property (strong, nonatomic) NSString *arabicTitle;
@property (strong, nonatomic) NSString *englishTitle;
@property (strong, nonatomic) NSString *englishFullName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *arabicNationalityCode;
@property (strong, nonatomic) NSString *englishNationalityCode;
@property (strong, nonatomic) NSString *englishNationality;
@property (strong, nonatomic) NSString *dateOfBirth;
@property (strong, nonatomic) NSString *arabicMotherFirstName;
@property (strong, nonatomic) NSString *englishMotherFirstName;
@property (strong, nonatomic) NSString *placeOfBirth;
@property (strong, nonatomic) NSString *arabicPlaceOfBirth;

@property (strong, nonatomic) NSString *occupationCode;
@property (strong, nonatomic) NSString *maritialStatusCode;
@property (strong, nonatomic) NSString *husbandIdn;
@property (strong, nonatomic) NSString *sponsorType;
@property (strong, nonatomic) NSString *sponsorNumber;
@property (strong, nonatomic) NSString *sponsorNameEnglish;
@property (strong, nonatomic) NSString *sponsorNameArabic;
@property (strong, nonatomic) NSString *residencyType;
@property (strong, nonatomic) NSString *residencyNumber;
@property (strong, nonatomic) NSString *residencyExpiryDate;
@property (strong, nonatomic) NSString *familyId;
@property (strong, nonatomic) NSString *passportNumber;
@property (strong, nonatomic) NSString *passportCountryArabic;
@property (strong, nonatomic) NSString *passportCountryEnglish;
@property (strong, nonatomic) NSString *passportCountryCodeEnglish;
@property (strong, nonatomic) NSString *passportIssueDate;
@property (strong, nonatomic) NSString *passportExpiryDate;
@property (strong, nonatomic) NSString *qualificationLevelDescriptionEnglish;
@property (strong, nonatomic) NSString *qualificationLevelDescriptionArabic;
@property (strong, nonatomic) NSString *degreeDescriptionArabic;
@property (strong, nonatomic) NSString *degreeDescriptionEnglish;
@property (strong, nonatomic) NSString *fieldOfStudyArabic;
@property (strong, nonatomic) NSString *fieldOfStudyEnglish;
@property (strong, nonatomic) NSString *dateOfGraduation;
@property (strong, nonatomic) NSString *occupationArabic;
@property (strong, nonatomic) NSString *occupationEnglish;
@property (strong, nonatomic) NSString *occupationTypeArabic;
@property (strong, nonatomic) NSString *occupationTypeEnglish;
@property (strong, nonatomic) NSString *companyNameArabic;
@property (strong, nonatomic) NSString *companyNameEnglish;
@property (strong, nonatomic) NSString *motherFullNameArabic;
@property (strong, nonatomic) NSString *motherFullNameEnglish;
@property (strong, nonatomic) NSString *emirateDescriptionEnglish;
@property (strong, nonatomic) NSString *emirateDescriptionArabic;
@property (strong, nonatomic) NSString *cityDescriptionEnglish;
@property (strong, nonatomic) NSString *cityDescriptionArabic;
@property (strong, nonatomic) NSString *streetDescriptionArabic;
@property (strong, nonatomic) NSString *streetDescriptionEnglish;
@property (strong, nonatomic) NSString *areaDescriptionEnglish;
@property (strong, nonatomic) NSString *areaDescriptionArabic;
@property (strong, nonatomic) NSString *buildingDescriptionEnglish;
@property (strong, nonatomic) NSString *buildingDescriptionArabic;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *poBox;

@property (strong, nonatomic) UIImage *signatureImage;

-(NSArray *)cardDesription;
@end
