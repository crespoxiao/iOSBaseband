//
//  CPBaseBand.m
//  BaseBandcommunication
//
//  Created by xiao chengfei on 14-3-8.
//  Copyright (c) 2014年 CrespoXiao. All rights reserved.
//

#import "CPBaseBand.h"

static CPBaseBand *_globalBaseBand;

@implementation CPBaseBand
@synthesize baseBand;

+ (CPBaseBand *)sharedInstance {
  if (!_globalBaseBand) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      _globalBaseBand = [[CPBaseBand alloc]init];
    });
  }
  return _globalBaseBand;
}


- (void)dealloc {
  baseBand = nil;
}


- (id)init {
  self = [super init];
  if (self) {
    
    baseBand = [NSFileHandle fileHandleForUpdatingAtPath:@"/dev/dlci.spi-baseband.extra_0"];
    if (baseBand == nil) {
      baseBand = [NSFileHandle fileHandleForUpdatingAtPath:@"/dev/tty.debug"];
      if (baseBand == nil) {
        NSLog(@"Can't open baseband.");
      }else{
        [self initSetting];
      }
    }else{
      [self initSetting];
    }
  }
  return self;
}

- (void)initSetting {
  int fd = [baseBand fileDescriptor];
  ioctl(fd, TIOCEXCL);
  fcntl(fd, F_SETFL, 0);
  static struct termios term;
  tcgetattr(fd, &term);
  cfmakeraw(&term);
  cfsetspeed(&term, 115200);
  term.c_cflag = CS8 | CLOCAL | CREAD;
  term.c_iflag = 0;
  term.c_oflag = 0;
  term.c_lflag = 0;
  term.c_cc[VMIN] = 0;
  term.c_cc[VTIME] = 0;
  tcsetattr(fd, TCSANOW, &term);
}

#pragma send at command

-(NSString *)sendATCommand:(NSFileHandle *)band andCommand:(NSString *)atCommand{
  NSLog(@"SEND AT: %@", atCommand);
  [band writeData:[atCommand dataUsingEncoding:NSASCIIStringEncoding]];
  NSMutableString *result = [NSMutableString string];
  NSData *resultData = [band availableData];
  while ([resultData length]) {
    [result appendString:[[NSString alloc] initWithData:resultData encoding:NSASCIIStringEncoding]];
    if ([result hasSuffix:@"OK\r\n"]||[result hasSuffix:@"ERROR\r\n"]) {
      NSLog(@"RESULT: %@", result);
      return [NSString stringWithString:result];
    }
    else{
      resultData = [band availableData];
    }
  }
  return nil;
}



#pragma mark - sim card

-(BOOL) addNewSIMContact:(NSFileHandle *)baseband andName:(NSString *)name andPhone:(NSString *)phone {
  NSString *result = [self sendATCommand:baseBand andCommand:@"AT+CPBS=\"SM\"\r"];
  result = [self sendATCommand:baseBand andCommand:@"AT+CSCS=\"UCS2\"\r"];
  result = [self sendATCommand:baseBand andCommand:@"ATE0\r"];
  
  result = [self sendATCommand:baseBand
                              andCommand:[NSString stringWithFormat:@"AT+CPBW=,\"%@\",,\"%@\"\r", phone, [name ucs2EncodingString]]];
  if ([result hasSuffix:@"OK\r\n"]) {
    return YES;
  }
  else{
    return NO;
  }
}

-(NSArray *)readAllSIMContacts:(NSFileHandle *)baseband{
  NSString *result = [self sendATCommand:baseBand andCommand:@"AT+CPBR=?\r"];
  if (![result hasSuffix:@"OK\r\n"]) {
    return nil;
  }
  int max = 0;
  sscanf([result UTF8String], "%*[^+]+CPBR: (%*d-%d)", &max);
  result = [self sendATCommand:baseBand andCommand:[NSString stringWithFormat:@"AT+CPBR=1,%d\r",max]];
  NSMutableArray *records = [NSMutableArray array];
  NSScanner *scanner = [NSScanner scannerWithString:result];
  [scanner scanUpToString:@"+CPBR:" intoString:NULL];
  while ([scanner scanString:@"+CPBR:" intoString:NULL]) {
    NSString *phone = nil;
    NSString *name = nil;
    [scanner scanInt:NULL];
    [scanner scanString:@",\"" intoString:NULL];
    [scanner scanUpToString:@"\"" intoString:&phone];
    [scanner scanString:@"\"," intoString:NULL];
    [scanner scanInt:NULL];
    [scanner scanString:@",\"" intoString:NULL];
    [scanner scanUpToString:@"\"" intoString:&name];
    [scanner scanUpToString:@"+CPBR:" intoString:NULL];
    if ([phone length] > 0 && [name length] > 0) {
      [records addObject:@{@"name":[name ucs2DecodingString], @"phone":phone}];
    }
  }
  return [NSArray arrayWithArray:records];
}


#pragma mark -  send sms

-(NSString *)PDUEncodeSendingSMS:(NSString *)phone andText:(NSString *)text{
  NSMutableString *string = [NSMutableString stringWithString:@"001100"];
  [string appendFormat:@"%02X", (int)[phone length]];
  if ([phone length]%2 != 0) {
    phone = [phone stringByAppendingString:@"F"];
  }
  [string appendFormat:@"81%@",[phone hexSwipString]];
  [string appendString:@"0008AA"];
  NSString *ucs2Text = [text ucs2EncodingString];
  [string appendFormat:@"%02x%@", (int)[ucs2Text length]/2, ucs2Text];
  return [NSString stringWithString:string];
}

-(BOOL) sendSMSWithPDUMode:(NSFileHandle *)baseband andPhone:(NSString *)phone andText:(NSString *)text{
  
  NSString *result = [self sendATCommand:baseBand andCommand:@"AT+CSCS=\"UCS2\"\r"];
  result = [self sendATCommand:baseBand andCommand:@"ATE0\r"];
  result = [self sendATCommand:baseBand andCommand:@"AT+CMGF=0\r"];
  
  
  NSString *pduString =[self PDUEncodeSendingSMS:phone andText:text];
  result = [self sendATCommand:baseBand
                              andCommand:[NSString stringWithFormat:@"AT+CMGS=%d\r", (int)[pduString length]/2-1]];
  result = [self sendATCommand:baseBand andCommand:[NSString stringWithFormat:@"%@\x1A", pduString]];
  if ([result hasSuffix:@"OK\r\n"]) {
    return YES;
  }
  else{
    return NO;
  }
}


@end
