//
//  NSString+Calculate.h
//  DDCategory
//
//  Created by SuperDanny on 15/4/8.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Calculate)

///加上bString
- (NSString *)stringByAdding:(NSString *)bString;
///减去bString
- (NSString *)stringBySubtracting:(NSString *)bString;
///乘以bString
- (NSString *)stringByMultiplyingBy:(NSString *)bString;
///除以bString
- (NSString *)stringByDividingBy:(NSString *)bString;
///是否大于bString
- (BOOL)isBig:(NSString *)bString;
///比较两个数大小
- (NSComparisonResult)ob_compare:(NSString *)bString;
///去掉尾巴是0或者.的位数(10.000 -> 10 // 10.100 -> 10.1)
- (NSString *)ridTail;
///保留数据类型2位小数(如果是10.000 -> 10 // 10.100 -> 10.1)
+ (NSString *)formatterNumber:(NSNumber *)number;
///保留数据类型fractionDigits位小数
+ (NSString *)formatterNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits;


@end
