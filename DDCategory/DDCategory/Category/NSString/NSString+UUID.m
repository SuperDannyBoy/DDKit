//
//  NSString+UUID.m
//  AnXin
//
//  Created by libiwu on 14/12/16.
//  Copyright (c) 2014年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "NSString+UUID.h"
#include <netdb.h>
#include <sys/socket.h>
#import "JNKeychain.h"

@implementation NSString (UUID)

+ (NSString*)stringWithUUID {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

+ (NSString*)stringWithSimpleUUID {
    NSString* uuid = [NSString stringWithUUID];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return [uuid lowercaseString];
}

+ (NSString *)deviceID {
    NSString *identifier = [JNKeychain loadValueForKey:(__bridge id)kSecAttrService];
    if ([identifier length] != 0) {
        NSLog(@"从keychain拿取UUID");
        return identifier;
    } else {
        NSLog(@"keychain中没有存储UUID， 重新获取，并存储");
        CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
        CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
        CFRelease(uuid_ref);
        NSString *strUUID = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
        CFRelease(uuid_string_ref);
        strUUID = [strUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [JNKeychain saveValue:strUUID forKey:(__bridge id)kSecAttrService];
        
        return strUUID;
    }
}

@end
