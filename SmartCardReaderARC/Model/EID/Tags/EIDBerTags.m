#import "EIDBerTags.h"
#import "BerTag.h"

@implementation EIDBerTags

//EIDFile0201
+(BerTag *)ID_NUMBER
{
    return [[BerTag alloc] init:0xE1 secondByte:0x01];
}

+(BerTag *)CARD_NUMBER
{
    return [[BerTag alloc] init:0xE1 secondByte:0x02];
}

//EIDFile0202
+(BerTag *)FACIAL_IMAGE
{
    return [[BerTag alloc] init:0x62 secondByte:0x03];
}

//EIDFile0203
+(BerTag *)ID_TYPE
{
    return [[BerTag alloc] init:0xE3 secondByte:0x05];
}

+(BerTag *)CARD_ISSUE_DATE
{
    return [[BerTag alloc] init:0x43 secondByte:0x06];
}

+(BerTag *)CARD_EXPIRY_DATE
{
    return [[BerTag alloc] init:0x43 secondByte:0x07];
}

+(BerTag *)ARABIC_TITLE
{
    return [[BerTag alloc] init:0xA3 secondByte:0x08];
}

+(BerTag *)ARABIC_FULL_NAME
{
    return [[BerTag alloc] init:0xA3 secondByte:0x09];
}

+(BerTag *)ENGLISH_TITLE
{
    return [[BerTag alloc] init:0xE3 secondByte:0x0A];
}

+(BerTag *)ENGLISH_FULL_NAME
{
    return [[BerTag alloc] init:0xE3 secondByte:0x0A];
}

+(BerTag *)GENDER_CODE
{
    return [[BerTag alloc] init:0xE3 secondByte:0x0C];
}

+(BerTag *)ARABIC_NATIONALITY_CODE
{
    return [[BerTag alloc] init:0xA3 secondByte:0x0D];
}

+(BerTag *)ENGLISH_NATIONALITY_CODE
{
    return [[BerTag alloc] init:0xE3 secondByte:0x0E];
}

+(BerTag *)ENGLISH_NATIONALITY
{
    return [[BerTag alloc] init:0xE3 secondByte:0x36];
}

+(BerTag *)DATE_OF_BIRTH
{
    return [[BerTag alloc] init:0x43 secondByte:0x0F];
}

+(BerTag *)ARABIC_MOTHER_FIRST_NAME
{
    return [[BerTag alloc] init:0xA3 secondByte:0x10];
}

+(BerTag *)ENGLISH_MOTHER_FIRST_NAME
{
    return [[BerTag alloc] init:0xE3 secondByte:0x11];
}

+(BerTag *)PLACE_OF_BIRTH
{
    return [[BerTag alloc] init:0xE3 secondByte:38];
}

+(BerTag *)ARABIC_PLACE_OF_BIRTH
{
    return [[BerTag alloc] init:0xA3 secondByte:37];
}

//TODO: Sponsor Type
//TODO: Sponsor Number
//TODO: Sponsor Name
//TODO: Residency Type
//TODO: Residency Number
//TODO: Residency Expiry-Date
//TODO: Card Number
//TODO: Occupation
//TODO: Maritial Status
//We don't need: Family ID/Husband IDN
//TODO: English_Nationality_Code parsing along to the spec.
//TODO: Gender_Code parsing along to the spec.

//EIDFile0205
// EF 0x0205
+(BerTag *)OCCUPATION_CODE
{
    return [[BerTag alloc] init:0x25 secondByte:0x15];
}

+(BerTag *)MARITIAL_STATUS_CODE
{
    return [[BerTag alloc] init:0x25 secondByte:0x16];
}

+(BerTag *)HUSBAND_IDN
{
    return [[BerTag alloc] init:0xe5 secondByte:0x17];
}

+(BerTag *)SPONSOR_TYPE
{
    return [[BerTag alloc] init:0x25 secondByte:0x18];
}

+(BerTag *)SPONSOR_NUMBER
{
    return [[BerTag alloc] init:0x25 secondByte:0x19];
}

+(BerTag *)SPONSOR_NAME_ENGLISH
{
    return [[BerTag alloc] init:0x25 secondByte:0x1a];
}

+(BerTag *)SPONSOR_NAME_ARABIC
{
    return [[BerTag alloc] init:0xa5 secondByte:0x1a];
}

+(BerTag *)RESIDENCY_TYPE
{
    return [[BerTag alloc] init:0x25 secondByte:0x1b];
}

+(BerTag *)RESIDENCY_NUMBER
{
    return [[BerTag alloc] init:0xe5 secondByte:0x1c];
}

+(BerTag *)RESIDENCY_EXPIRY_DATE
{
    return [[BerTag alloc] init:0x45 secondByte:0x1d];
}

+(BerTag *)FAMILY_ID
{
    return [[BerTag alloc] init:0xe5 secondByte:0x20];
}

+(BerTag *)PASSPORT_NUMBER
{
    return [[BerTag alloc] init:0xe5 secondByte:0x26];
}

+(BerTag *)PASSPORT_COUNTRY_ARABIC
{
    return [[BerTag alloc] init:0xa5 secondByte:0x3b];
}

+(BerTag *)PASSPORT_COUNTRY_ENGLISH
{
    return [[BerTag alloc] init:0xe5 secondByte:0x3c];
}

+(BerTag *)PASSPORT_COUNTRY_CODE_ENGLISH
{
    return [[BerTag alloc] init:0xe5 secondByte:0x28];
}

+(BerTag *)PASSPORT_ISSUE_DATE
{
    return [[BerTag alloc] init:0x45 secondByte:0x29];
}

+(BerTag *)PASSPORT_EXPIRY_DATE
{
    return [[BerTag alloc] init:0x45 secondByte:0x2a];
}

+(BerTag *)QUALIFICATION_LEVEL_DESCRIPTION_ARABIC
{
    return [[BerTag alloc] init:0xa5 secondByte:0x3d];
}

+(BerTag *)QUALIFICATION_LEVEL_DESCRIPTION_ENGLISH
{
    return [[BerTag alloc] init:0xe5 secondByte:0x3e];
}

+(BerTag *)DEGREE_DESCRIPTION_ARABIC
{
    return [[BerTag alloc] init:0xa5 secondByte:0x2c];
}

+(BerTag *)DEGREE_DESCRIPTION_ENGLISH
{
    return [[BerTag alloc] init:0xe5 secondByte:0x2d];
}

+(BerTag *)FIELD_OF_STUDY_ARABIC
{
    return [[BerTag alloc] init:0xa5 secondByte:0x3f];
}

+(BerTag *)FIELD_OF_STUDY_ENGLISH
{
    return [[BerTag alloc] init:0xa5 secondByte:0x40];
}

+(BerTag *)DATE_OF_GRADUATION
{
    return [[BerTag alloc] init:0x45 secondByte:0x31];
}

+(BerTag *)OCCUPATION_ARABIC
{
    return [[BerTag alloc] init:0xa5 secondByte:0x39];
}

+(BerTag *)OCCUPATION_ENGLISH
{
    return [[BerTag alloc] init:0xe5 secondByte:0x3a];
}

+(BerTag *)OCCUPATION_TYPE_ARABIC
{
    return [[BerTag alloc] init:0xa5 secondByte:0x21];
}

+(BerTag *)OCCUPATION_TYPE_ENGLISH
{
    return [[BerTag alloc] init:0xe5 secondByte:0x22];
}

+(BerTag *)COMPANY_NAME_ARABIC
{
    return [[BerTag alloc] init:0xa5 secondByte:0x24];
}

+(BerTag *)COMPANY_NAME_ENGLISH
{
    return [[BerTag alloc] init:0xe5 secondByte:0x25];
}

+(BerTag *)MOTHER_FULL_NAME_ARABIC
{
    return [[BerTag alloc] init:0xa5 secondByte:0x10];
}

+(BerTag *)MOTHER_FULL_NAME_ENGLISH
{
    return [[BerTag alloc] init:0xe5 secondByte:0x11];
}

// EF 0x0A02

+(BerTag *)EMIRATE_DESCRIPTION_ENGLISH
{
    return [[BerTag alloc] init:0xe2 secondByte:0x05];
}

+(BerTag *)EMIRATE_DESCRIPTION_ARABIC
{
    return [[BerTag alloc] init:0xa2 secondByte:0x04];
}

+(BerTag *)CITY_DESCRIPTION_ENGLISH
{
    return [[BerTag alloc] init:0xe2 secondByte:0x08];
}

+(BerTag *)CITY_DESCRIPTION_ARABIC
{
    return [[BerTag alloc] init:0xa2 secondByte:0x07];
}

+(BerTag *)STREET_DESCRIPTION_ENGLISH
{
    return [[BerTag alloc] init:0xe2 secondByte:0x0a];
}

+(BerTag *)STREET_DESCRIPTION_ARABIC
{
    return [[BerTag alloc] init:0xa2 secondByte:0x09];
}

+(BerTag *)AREA_DESCRIPTION_ENGLISH
{
    return [[BerTag alloc] init:0xe2 secondByte:0x0e];
}

+(BerTag *)AREA_DESCRIPTION_ARABIC
{
    return [[BerTag alloc] init:0xa2 secondByte:0x0d];
}

+(BerTag *)BUILDING_DESCRIPTION_ENGLISH
{
    return [[BerTag alloc] init:0xe2 secondByte:0x10];
}

+(BerTag *)BUILDING_DESCRIPTION_ARABIC
{
    return [[BerTag alloc] init:0xa2 secondByte:0x0f];
}

+(BerTag *)PHONE
{
    return [[BerTag alloc] init:0xe2 secondByte:0x12];
}

+(BerTag *)MOBILE
{
    return [[BerTag alloc] init:0xe2 secondByte:0x13];
}

+(BerTag *)PO_BOX
{
    return [[BerTag alloc] init:0xe2 secondByte:0x0b];
}

//EIDFILE02x07

+(BerTag *)SIGNATURE_IMAGE
{
    return [[BerTag alloc] init:0x67 secondByte:0x32];
}

@end
