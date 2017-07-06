//
//  CheckTools.m
//
//  Created by SuperDanny on 15/3/27.
//  Copyright © 2017年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.//

#import "CheckTools.h"
#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

//判断是否是ios7系统以上
#define isiOS7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@implementation CheckTools

#pragma mark - 判断手机权限
+ (BOOL)isPermissionsWithType:(PermissionsType)type {
    BOOL isPermit = NO;
    switch (type) {
        case CameraPermissions:
            isPermit = [self cameraPermissions];
            break;
        case PhotoPermissions:
            isPermit = [self photoPermissions];
            break;
        case MicrophonePermissions:
            isPermit = [self microphonePermissions];
            break;
        case AddressBookPermissions:
            isPermit = [self addressBookPermissions];
            break;
        default:
            break;
    }
    return isPermit;
}

+ (BOOL)cameraPermissions {
    __block BOOL isPermit = YES;
    if (isiOS7) {
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusAuthorized) {
            isPermit = YES;
        }
        else if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
            isPermit = NO;
        }
        else {
            isPermit = YES;
        }
    }
    return isPermit;
}

+ (BOOL)photoPermissions {
    BOOL isPermit = YES;
    if (isiOS7) {
        ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
        if (authorizationStatus == ALAuthorizationStatusAuthorized) {
            isPermit = YES;
        }
        else if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
            isPermit = NO;
        }
        else {
            isPermit = YES;
        }
    }
    return isPermit;
}

+ (BOOL)microphonePermissions {
    __block BOOL isPermit = YES;
    if (isiOS7) {
        AVAudioSession *session = [[AVAudioSession alloc] init];
        if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
            [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    isPermit = YES;
                } else {
                    isPermit = NO;
                }
            }];
        }
    }
    return isPermit;
}

+ (BOOL)addressBookPermissions {
    __block BOOL isPermit = YES;
    //用户拒绝访问通讯录,给用户提示设置应用访问通讯录
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authorizationStatus == ALAuthorizationStatusAuthorized) {
        isPermit = YES;
    }
    else if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        isPermit = NO;
    }
    else {
        isPermit = YES;
    }
    return isPermit;
}

@end
