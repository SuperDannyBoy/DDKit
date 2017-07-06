//
//  NSString+Unicode.h
//  DDCategory
//
//  Created by SuperDanny on 15/5/7.
//  Copyright (c) 2015年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Unicode)

/**
 *  将字符转成unicode编码
 *
 *  @param str 转前字符
 *
 *  @return 转后字符
 */
+ (NSString *)replaceUnicode:(NSString *)str;

/**
 *  将unicode编码转成汉字
 *
 *  @param unicodeStr 转前字符
 *
 *  @return 转后字符
 */
+ (NSString *)replaceUnicodeToHanzi:(NSString *)unicodeStr;

@end
