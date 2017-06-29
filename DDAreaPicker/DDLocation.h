//
//  DDLocation.h
//  AreaPicker
//
//  Created by SuperDanny on 15/11/10.
//  Copyright © 2015年 SuperDanny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDLocation : NSObject

///邮政编码
@property (copy, nonatomic) NSString *zipCode;
///国家
@property (copy, nonatomic) NSString *country;
///省
@property (copy, nonatomic) NSString *state;
///市
@property (copy, nonatomic) NSString *city;
///区
@property (copy, nonatomic) NSString *district;
///街道
@property (copy, nonatomic) NSString *street;
///纬度
@property (nonatomic) double latitude;
///经度
@property (nonatomic) double longitude;

@end
