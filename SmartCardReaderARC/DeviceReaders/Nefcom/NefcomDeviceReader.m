#import "NefcomDeviceReader.h"
#import "NSArray+ByteManipulation.h"
#import "CAPDU.h"
#import "RAPDU.h"
//#import "lbrReader.h"

//@interface NefcomDeviceReader() <lbrReaderDelegate, BLEReaderDelegate>

//@property (strong, nonatomic) lbrReader* reader;

//@end

@implementation NefcomDeviceReader

//@synthesize delegate;
//#pragma mark = CardReaderCommandExecutioner
//
//-(void)prepareCard
//{
//    self.reader = [[lbrReader alloc] init];
//    [self.reader setDelegate:self];
//    [self.reader initReader];
//}
//
//- (RAPDU *)executeCommand:(CAPDU *)capdu error:(NSError *__autoreleasing *)error
//{
//
//    unsigned char buffer[255] = {0};
//    unsigned char *command = [capdu.bytes cArrayFromBytes];
//    unsigned int rdl;
//    rdl = sizeof(buffer);
//
//    int status = [self.reader SCTransmit :command
//                                         :(u_int32_t)capdu.bytes.count
//                                         :buffer
//                                         :&rdl];
//
//    int responseLength = (int)rdl;
//
//    if(status == 0)
//    {
//        RAPDU *responseAPDU = [[RAPDU alloc] initWithResponseBytes:buffer
//                                                         andLength:responseLength];
//
//        if (responseAPDU.responseStatus == RAPDUStatusOther) {
//
//            NSMutableDictionary* details = [NSMutableDictionary dictionary];
//            [details setValue:[NSString stringWithFormat:@"ERROR FOR CAPDU: %@.\nRAPDU STATUS BYTES: %c %c", capdu.bytes, responseAPDU.byteBeforeLast.unsignedShortValue, responseAPDU.lastByte.unsignedShortValue] forKey:NSLocalizedDescriptionKey];
//            if (error) {
//                *error = [NSError errorWithDomain:@"Error Reading From Card" code:200 userInfo:details];
//            }
//
//            return nil;
//
//        }else if (responseAPDU.responseStatus == RAPDUStatusNoBytes) {
//
//            NSMutableDictionary* details = [NSMutableDictionary dictionary];
//            [details setValue:@"" forKey:NSLocalizedDescriptionKey];
//            if (error) {
//                *error = [NSError errorWithDomain:@"Nefcom Reader Error" code:200 userInfo:details];
//            }
//
//            return nil;
//        }
//
//        return responseAPDU;
//
//    }else{
//
//        NSMutableDictionary* details = [NSMutableDictionary dictionary];
//        [details setValue:@"Command not sent" forKey:NSLocalizedDescriptionKey];
//        if (error) {
//            *error = [NSError errorWithDomain:@"Nefcom Reader Error" code:200 userInfo:details];
//        }
//
//        return nil;
//    }
//}
//
//- (void)finalizeCard
//{
//    int disconnectStatus = [self.reader DisconnectCard];
//    if (disconnectStatus == LT_OK) {
//        int closeReaderStatus = [self.reader CloseReader];
//        if (closeReaderStatus == LT_OK) {
//            [self.delegate didFinalizeCardSuccessfully];
//        }else {
//            NSError *error = [NSError errorWithDomain:@"Nefcom Error Domain"
//                                             code:closeReaderStatus
//                                         userInfo:nil];
//            [self.delegate didFailFinalizeCardWithError:error];
//        }
//    }else{
//        NSError *error = [NSError errorWithDomain:@"Nefcom Error Domain"
//                                             code:disconnectStatus
//                                         userInfo:nil];
//        [self.delegate didFailFinalizeCardWithError:error];
//    }
//
//}
//
//
//#pragma mark - lbrReaderDelegate
//
//-(void)didDiscoverReader:(NSString *)name UUID:(NSString *)uuid index:(int)idx
//{
//    NSLog(@"did discover reader %@", name);
//}
//
//- (void)didConnectLBRReader:(int *)iConnectionStatus
//{
//    int b = *iConnectionStatus;
//    NSLog(@"status b : %i", b);
//    if (b == 1) {
//        //prepare
//        dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
//
//            int status = LTERR;
//            int cardStatus = SC_CARD_ABSENT;
//
//            NSError *error;
//
//            status = [self.reader ConfigReader];
//            if(status != LT_OK) {
//
//                NSMutableDictionary* details = [NSMutableDictionary dictionary];
//                [details setValue:@"Config Reader Failed" forKey:NSLocalizedDescriptionKey];
//                error = [NSError errorWithDomain:@"Nefcom Reader Error" code:200 userInfo:details];
//
//                [self.delegate didFailPrepareCardWithError:error];
//                return;
//            }
//
//            status = [self.reader GetCardStatus :&cardStatus];
//            if(status == LT_OK)
//            {
//                if(cardStatus == SC_CARD_ABSENT) {
//
//                    NSMutableDictionary* details = [NSMutableDictionary dictionary];
//                    [details setValue:@"No Card!" forKey:NSLocalizedDescriptionKey];
//                    error = [NSError errorWithDomain:@"Nefcom Reader Error" code:200 userInfo:details];
//
//                    [self.delegate didFailPrepareCardWithError:error];
//                    return;
//                }
//            }
//
//            status = [self.reader ConnectSCCard];
//            if(status != LT_OK) {
//                NSMutableDictionary* details = [NSMutableDictionary dictionary];
//                [details setValue:@"Connect Card Failed" forKey:NSLocalizedDescriptionKey];
//                error = [NSError errorWithDomain:@"Nefcom Reader Error" code:200 userInfo:details];
//
//                [self.delegate didFailPrepareCardWithError:error];
//                return;
//            }
//            else {
//
//                [self.delegate didPrepareCardSuccessfully];
//            }
//        });
//    }else{
//        [self finalizeCard];
//    }
//
//
//}
//
//- (void)didConnectCLSReader:(int *)iConnectionStatus
//{
//    //do nothing
//}
//
//- (void)EnrollImageCallBack:(UIImage *)image
//{
//    //do nothing
//}

@end
