//
//  NSString+UUID.h
//  AnXin
//
//  Created by libiwu on 14/12/16.
//  Copyright (c) 2014年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
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
