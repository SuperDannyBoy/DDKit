//
//  NSString+Addition.h
//  DDCategory
//
//  Created by SuperDanny on 15/4/8.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
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
 *
 *  将HTML特殊字符转成正常字符
 *
 *  @return 正常字符
 */
- (NSString *)stringByDecodingXMLEntities;

/**
 *
 *  将特殊字符转义成HTML识别字符
 *
 *  @return 转义字符
 */
- (NSString *)stringByXMLToESC;

/**
 *
 *  URLEncodedString(编码)
 *
 *  @return 编码后字符串
 */
- (NSString *)URLEncodedString;

/**
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
