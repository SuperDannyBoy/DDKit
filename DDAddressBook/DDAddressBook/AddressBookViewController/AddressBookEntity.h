//
//  AddressBookEntity.h
//  DDAddressBook
//
//  Created by SuperDanny on 15/3/30.
//  Copyright (c) 2015年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookEntity : NSObject <NSCoding>

/**
 *  姓名
 */
@property (copy, nonatomic) NSString *nameStr;
/**
 *  电话号码
 */
@property (copy, nonatomic) NSString *phoneStr;
/**
 *  邮箱
 */
@property (copy, nonatomic) NSString *emailStr;

- (NSString *)phoneStr;
@end
