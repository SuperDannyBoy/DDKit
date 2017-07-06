//
//  CheckTools.h
//  DLMacaoApp
//
//  Created by libiwu on 14-6-19.
//  Copyright (c) 2014年 andy_wu. All rights reserved.
//
//  逻辑检查工具

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

///相机、相册、麦克风、通讯录
typedef NS_ENUM(NSUInteger, PermissionsType) {
    ///相机权限
    CameraPermissions,
    ///相册权限
    PhotoPermissions,
    ///麦克风权限
    MicrophonePermissions,
    ///通讯录权限
    AddressBookPermissions,
};

@interface CheckTools : NSObject
/**
 *  判断手机权限（相机、相册、麦克风、通讯录）
 *
 *  @param type 权限类型
 *
 *  @return 是否开启权限
 */
+ (BOOL)isPermissionsWithType:(PermissionsType)type;

@end
