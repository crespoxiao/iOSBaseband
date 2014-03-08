//
//  NSString+UCS2Encoding.h
//  BaseBandcommunication
//
//  Created by CrespoXiao on 14-3-8.
//  Copyright (c) 2014年 CrespoXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(UCS2Encoding)
- (NSString*)ucs2EncodingString;
- (NSString*)ucs2DecodingString;
- (NSString*)hexSwipString;
@end
