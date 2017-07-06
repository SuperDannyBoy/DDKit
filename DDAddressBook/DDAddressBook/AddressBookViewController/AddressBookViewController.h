//
//  AddressBookViewController.h
//  DDAddressBook
//
//  Created by SuperDanny on 15/3/27.
//  Copyright (c) 2015年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//
//  通讯录

#import <UIKit/UIKit.h>
#import "AddressBookEntity.h"

#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width
//判断是否是ios7系统以上
#define isiOS7          ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

typedef void(^GetPhoneNumber)(AddressBookEntity *entity);

@interface AddressBookViewController : UIViewController

@property (copy, nonatomic) GetPhoneNumber block;

/**
 *  获取通讯录
 *
 *  @return 返回通讯录数组
 */
+ (NSArray<AddressBookEntity *> *)getAddressBookArray;

///匹配通讯录是否有输入的联系人
+ (NSArray *)filteredContentForSearchString:(NSString *)searchString;

@end
