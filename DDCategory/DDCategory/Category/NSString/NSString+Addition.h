//
//  NSString+Addition.h
//  DDCategory
//
//  Created by libiwu on 15/4/23.
//  Copyright (c) 2015年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

///替换空数据
+ (NSString *)filterNULLValue:(NSString *)string;

///计算 size
- (NSString *)MD5;

///计算 size
- (CGSize)newSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *  @author LvChanghui, 15-10-15 16:10:46
 *
 *  将HTML特殊字符转成正常字符
 *
 *  @return 正常字符
 */
- (NSString *)stringByDecodingXMLEntities;

/**
 *  @author LvChanghui, 15-10-15 16:10:46
 *
 *  将特殊字符转义成HTML识别字符
 *
 *  @return 转义字符
 */
- (NSString *)stringByXMLToESC;

/**
 *  @author LvChanghui, 16-1-3 16:10:46
 *
 *  URLEncodedString(编码)
 *
 *  @return 编码后字符串
 */
- (NSString *)URLEncodedString;

/**
 *  @author LvChanghui, 16-1-3 16:10:46
 *
 *  URLDecodedString(解码)
 *
 *  @return 解码后字符串
 */
- (NSString *)URLDecodedString;

///金额转大写
+ (NSString *)digitUppercaseWithMoney:(NSString *)money;

///获取设备型号
+ (NSString *)deviceVersion;

@end
