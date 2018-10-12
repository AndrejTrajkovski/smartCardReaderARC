//
//  EIDCardModel.h
//  SmartCardReaderARC
//
//  Created by Andrej Trajkovski on 10/1/18.
//  Copyright © 2018 Andrej Trajkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EIDBaseFile;
@interface EIDCardModel : NSObject

@property (strong, nonatomic) NSArray<EIDBaseFile *> *files;
@property (strong, nonatomic) NSString *cardId;
@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSData *file1; 

@end
