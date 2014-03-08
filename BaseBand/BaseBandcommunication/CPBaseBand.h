//
//  CPBaseBand.h
//  BaseBandcommunication
//
//  Created by xiao chengfei on 14-3-8.
//  Copyright (c) 2014年 CrespoXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <termios.h>
#import <time.h>
#import <sys/ioctl.h>
#import "NSString+UCS2Encoding.h"


@interface CPBaseBand : NSObject
+ (CPBaseBand *)sharedInstance;
@property(nonatomic,strong)NSFileHandle *baseBand;

-(NSString *)sendATCommand:(NSFileHandle *)band andCommand:(NSString *)atCommand;
-(BOOL) addNewSIMContact:(NSFileHandle *)baseband andName:(NSString *)name andPhone:(NSString *)phone;
-(NSArray *)readAllSIMContacts:(NSFileHandle *)baseband;
-(NSString *)PDUEncodeSendingSMS:(NSString *)phone andText:(NSString *)text;
-(BOOL) sendSMSWithPDUMode:(NSFileHandle *)baseband andPhone:(NSString *)phone andText:(NSString *)text;
@end
