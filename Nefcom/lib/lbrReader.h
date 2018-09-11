//
//  umBiometric.h
//  umBiometric
//
//  Created by Nefcom Technology on 23/12/16.
//  Copyright © 2016 Nefcom Technology. All rights reserved.
//  SDK_VERSION @"Lightning Smartcard Biometric v3.4.0.0”

#import <Foundation/Foundation.h>
#import "BLEReader.h"
#import "BLENfcReader.h"

//General Error Code
#define LT_OK                       0
#define LTERR                       -100
#define LTERR_INVALID_PARAMETER     -101
#define LTERR_NO_DEV                -102
#define LTERR_OPEN_DEV_FAIL         -103
#define LTERR_DISABLED              -104
#define LTERR_NOT_CONNECTED         -105
#define LTERR_NO_IO_STREAM          -106
#define LTERR_TIMEOUT               -107
#define LTERR_IO                    -108
#define LTERR_NO_RESP               -109
#define LTERR_FRAME                 -110
#define LTERR_INVALID_DEV           -111
#define LTERR_CRYPTO                -112
#define LTERR_AUTHENTICATE          -113

//Biometric Error Code
//No error
#define BIO_OK                      0
//Biometrics device performed an internal error
#define BIOERR_INTERNAL             -1
//Communication protocol error
#define BIOERR_PROTOCOLE            -2
//Can not connect biometrics device
#define BIOERR_CONNECT              -3
//Not enough memory for the creation of a database in module
#define BIOERR_NO_SPACE_LEFT        -7
//unknown status error
#define BIOERR_STATUS               -9
//The database is full
#define BIOERR_DB_FULL              -10
//The database is empty
#define BIOERR_DB_EMPTY             -11
//User has already been enrolled
#define BIOERR_ALREADY_ENROLLED     -12
//The specified base does not exist
#define BIOERR_BASE_NOT_FOUND       -13
//The specified base already exist
#define BIOERR_BASE_ALREADY_EXISTS  -14
//The template is not valid
#define BIOERR_INVALID_TEMPLATE     -17
//No response after defined time
#define BIOERR_TIMEOUT             -19
//Invalid PK format
#define BIOERR_INVALID_PK_FORMAT     -27
//The user data are not valid
#define BIOERR_INVALID_USER_ID      -30
#define BIOERR_INVALID_USER_DATA      -31
//User is not found
#define BIOERR_USER_NOT_FOUND       -33
#define BIOERR_FINGER_MISPLACED_OR_WITHDRAWN -34
#define BIOERR_FFD_FINGER_MISPLACED         -35
#define BIOERR_CMD_ABORTED         -36
#define BIOERR_FFD                  -37
#define BIOERR_DEV_NOT_CONNECTED    -40
#define BIOERR_NO_TEMPLATE          -41

//Smartcard status
#define SC_CARD_PRESENT             1
#define SC_CARD_ABSENT              0

//Smartcard Error Code
#define SCERR                       -150
#define SCERR_INVALID_PARAMETER     -151
#define SCERR_READER_NOT_AVAILABLE  -152
#define SCERR_CARD_NO_RSP           -153
#define SCERR_OPEN_READER_FAIL      -154
#define SCERR_NO_DEV                -155
#define SCERR_CARD_REMOVED          -156
#define SCERR_NO_CARD               -157
#define SCERR_CARD_FAILED           -158
#define SCERR_IO_FAILED             -159
#define SCERR_UNKNOWN_CARD          -160
#define SCERR_DEV_INIT_FAILED       -161
#define SCERR_DEV_FAILED            -162

//Enrollment / verification status code
#define BIO_NO_FINGER               40
#define BIO_FINGER_UP               41
#define BIO_FINGER_DOWN             42
#define BIO_FINGER_LEFT             43
#define BIO_FINGER_RIGHT            44
#define BIO_FINGER_PRESS_HARDER     45
#define BIO_FINGER_LATENT           46
#define BIO_FINGER_REMOVE           47
#define BIO_FINGER_OK               48

#define BIO_FINGER_MATCHED          0
#define BIO_FINGER_NOT_MATCH        -8

//Lighthign device status
#define LTDEV_CONNECTED               1
#define LTDEV_NOT_CONNECTED           0

// Biometric template format type
// For Bio_EnrollExportPK and Bio_VerifyPK
#define PK_COMP_V2                  0x00
#define PK_MAT                      0x02
#define PK_MAT_NORM                 0x03 //for verify only
#define ANSI_INCITS_378_2004        0x41
#define ISO_19794_2 FMR_2011        0x4C //ISO/IEC 19794-2 Finger Minutiae Record version 2011
#define ANSI_INCITS_378_2009        0x4D
#define ISO_19794_2_FMR_CS          0x6C //ISO/IEC 19794-2 Finger Minutiae Card Record, Compact Size.
#define ISO_19794_2_FMR_NS          0x6D //ISO/IEC 19794-2 Finger Minutiae Card Record, Normal Size.
#define ISO_19794_2_FMR             0x6E
#define MINEX_A                     0x6F
#define DIN_V66400_FMR              0x7D
#define DIN_V66400_FMR_CS_AA        0x7E
#define ISO_19794_2_FMR_CS_AA       0x7F //ISO/IEC 19794-2 Finger Minutiae Card Record, Compact Size, minutiae ordered by Ascending Angle

typedef enum BIO_EXPORT_IMAGE_TYPE : NSUInteger {
    BIO_RAW_IMAGE,      /*Export Raw Image with Morpho Header*/
    BIO_BITMAP_IMAGE    /* Export Raw Image with Bitmap Header*/
} BIO_EXPORT_IMAGE_TYPE;

struct CardInfo {
    uint8_t bOriginalName[150];
    uint8_t bGMPCName[80];
    uint8_t bKPTShortName[40];
    uint8_t bID[13];
    uint8_t bGender[1];
    uint8_t bOldID[8];
    uint8_t bBirthDate[4];
    uint8_t bBirthPlace[25];
    uint8_t bIssueDate[4];
    uint8_t bCitizenship[18];
    uint8_t bRace[25];
    uint8_t bReligion[11];
    uint8_t bEastMalaysian[1];
    uint8_t bRJ[2];
    uint8_t bKT[2];
    uint8_t bOtherID[11];
    uint8_t bCategory[1];
    uint8_t bCardVer[1];
    uint8_t bGreenCardExp[4];
    uint8_t bGreenCardNationality[20];
    
    uint8_t bAddress1[30];
    uint8_t bAddress2[30];
    uint8_t bAddress3[30];
    uint8_t bPostcode[3];
    uint8_t bCity[25];
    uint8_t bState[30];
} ;

@protocol lbrReaderDelegate;

@protocol lbrReaderDelegate <NSObject>
@required
- (void) didConnectLBRReader:(int *)iConnectionStatus; // to get the status of the BT device connection, 1:Connected, 0:Not Connected
- (void) didConnectCLSReader:(int *)iConnectionStatus; // to get the status of the NFC device connection, 1:Connected, 0:Not Connected
- (void) EnrollImageCallBack :(UIImage *) image;
@end

@interface lbrReader : NSObject <BLEReaderDelegate>
@property (nonatomic, strong) BLENfcReader* CLSReader;

@property (nonatomic, weak) id <lbrReaderDelegate> delegate;


//----------------------------------------------------------
// Reader functions
//----------------------------------------------------------
- (id) init;
- (int) initReader;                                        //search and wait for Lightning device
- (unsigned int) CloseReader;                               //Close Reader connection
- (int) IsDeviceConnect;                                    //check LT device connection status :: return 1=device connected, 0=device not ready
- (NSString*) GetSDKVersion;
- (NSString*) GetFWVersion;

//----------------------------------------------------------
// Generic Smartcard Functions
//----------------------------------------------------------
- (unsigned int) ConnectSCCard;         //Connect generic Smartcard
- (unsigned int) SCTransmit:(uint8_t *)inCmdBuffer :(uint32_t)inBufferLen :(uint8_t *)outCmdBuffer :(uint32_t *)oBufferLen;
- (unsigned int) ConfigReader;                                      //Configure smartcard Reader
- (unsigned int) GetCardStatus :(int *)cardStatus;                   //Get card status
- (unsigned int) DisconnectCard;

//----------------------------------------------------------
// Contactless Functions
//----------------------------------------------------------
- (int) ConnectCLSDevice;
- (unsigned int) ConnectCLSCard;
- (unsigned int) CLSTransmit:(uint8_t *)inCmdBuffer :(uint32_t)inBufferLen :(uint8_t *)outCmdBuffer :(uint32_t *)oBufferLen;
- (void) DisonnectCLSCard;
- (void) CloseCLSReader;

//----------------------------------------------------------
// MyKad Functions
//----------------------------------------------------------

- (unsigned int) ConnectCard;   //Connect MyKad
- (unsigned int) MyKadOriName:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadGMPCName:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadKPTShortName:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadIDNum:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadOldIDNum:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadAdd1:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadAdd2:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadAdd3:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadPKRight:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadPKLeft:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadGender:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadCitizenship:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadCity:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadBirthPlace:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadBirthDate:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadIssueDate:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadImage:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadState:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadPostcode:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadRace:(bool) bSecure :(NSData **) outdata;
- (unsigned int) MyKadReligion:(bool) bSecure :(NSData **) outdata;
- (unsigned int) getDetails:(bool) bSecure :(struct CardInfo *) CardInfo;
- (unsigned int) getMinutiae:(bool) bSecure :(NSData **) outdata;

//----------------------------------------------------------
//Biometric Functions
//----------------------------------------------------------
- (unsigned int) Bio_Connect;                              //Connect to biometric module
- (unsigned int) Bio_Disconnect;                           //disconnect biometric module
- (unsigned int) Bio_GetDescriptor :(NSData *)descData;     //Biometric descriptor info
- (unsigned int) Bio_Verify :(uint8_t *)TemplateData :(int)iTimeout :(int **)iMatchStatus :(unsigned int *)verifyResp;     //Verify with MyKad Right/Left minutiae
- (unsigned int) Bio_VerifyPK :(uint8_t)templateType :(uint8_t *)TemplateData :(int)inTemplateLen :(int)iTimeout :(int **)iMatchStatus :(unsigned int *)verifyResp; //Verify with external template data
- (unsigned int) Bio_EnrollExportPK :(int)iExportImage :(uint8_t)templateType :(int)iTimeout :(uint8_t *)oTemplateData :(int *)ioTemplateLength :(uint8_t *)oImageData :(int *)ioImageLength;

@end






