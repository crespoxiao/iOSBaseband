//
//  NSString+UCS2Encoding.m
//  BaseBandcommunication
//
//  Created by xiao chengfei on 14-3-8.
//  Copyright (c) 2014年 CrespoXiao. All rights reserved.
//

#import "NSString+UCS2Encoding.h"

@implementation NSString(UCS2Encoding)

- (NSString*)ucs2EncodingString{
  NSMutableString *result = [NSMutableString string];
  for (int i = 0; i < [self length]; i++) {
    unichar unic = [self characterAtIndex:i];
    [result appendFormat:@"%04hX",unic];
  }
  return [NSString stringWithString:result];
}

- (NSString*)ucs2DecodingString{
  NSUInteger length = [self length]/4;
  unichar *buf = malloc(sizeof(unichar)*length);
  const char *scanString = [self UTF8String];
  for (int i = 0; i < length; i++) {
    sscanf(scanString+i*4, "%04hX", buf+i);
  }
  return [[NSString alloc] initWithCharacters:buf length:length];
}

- (NSString*)hexSwipString{
  unichar *oldBuf = malloc([self length]*sizeof(unichar));
  unichar *newBuf = malloc([self length]*sizeof(unichar));
  [self getCharacters:oldBuf range:NSMakeRange(0, [self length])];
  for (int i = 0; i < [self length]; i+=2) {
    newBuf[i] = oldBuf[i+1];
    newBuf[i+1] = oldBuf[i];
  }
  NSString *result = [NSString stringWithCharacters:newBuf length:[self length]];
  free(oldBuf);
  free(newBuf);
  return result;
}

@end
