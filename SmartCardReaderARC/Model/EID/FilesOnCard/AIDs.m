#import "AIDs.h"
#import "EIDFiles.h"

@implementation AID01

-(NSArray *)aid
{
    return @[@0xA0, @0x00, @0x00, @0x02, @0x43, @0x00, @0x13, @0x00, @0x00, @0x00, @0x01, @0x01, @0x01];
}

- (NSArray *)filesList
{
    if (!_filesList) {
        EIDFile0201 *fileOne = [EIDFile0201 new];
        EIDFile0202 *fileTwo = [EIDFile0202 new];
        EIDFile0203 *fileThree = [EIDFile0203 new];
        EIDFile0205 *fileFour = [EIDFile0205 new];
        EIDFile0207 *fileSix = [EIDFile0207 new];
        _filesList =  @[fileOne, fileTwo, fileThree, fileFour, fileSix];
    }
    return _filesList;
}

@end

@implementation AID09

-(NSArray *)aid
{
    return @[@0xA0, @0x00, @0x00, @0x02, @0x43, @0x00, @0x13, @0x00, @0x00, @0x00, @0x01, @0x01, @0x09];
}

- (NSArray *)filesList
{
    if (!_filesList) {
        EIDFile0A02 *fileOne = [EIDFile0A02 new];
        _filesList =  @[fileOne];
    }
    return _filesList;
}

@end
