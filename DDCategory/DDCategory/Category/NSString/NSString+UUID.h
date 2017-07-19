//
//  NSString+UUID.h
//  DDCategory
//
//  Created by SuperDanny on 15/8/6.
//  Copyright © 2015年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UUID)

///唯一字符串
+ (NSString*)stringWithUUID;

///小写的,去掉'-'的唯一字符串
+ (NSString*)stringWithSimpleUUID;

///获取唯一性的UUID
+ (NSString *)deviceID;

@end
