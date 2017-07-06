//
//  AddressBookEntity.m
//  DDAddressBook
//
//  Created by SuperDanny on 15/3/30.
//  Copyright (c) 2015年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "AddressBookEntity.h"

@implementation AddressBookEntity

#pragma mark- NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.nameStr forKey:@"UserName"];
    [aCoder encodeObject:self.phoneStr forKey:@"UserPhone"];
    [aCoder encodeObject:self.emailStr forKey:@"UserEmail"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    _nameStr  = [aDecoder decodeObjectForKey:@"UserName"];
    _phoneStr = [aDecoder decodeObjectForKey:@"UserPhone"];
    _emailStr = [aDecoder decodeObjectForKey:@"UserEmail"];
    return self;
}

- (NSString *)phoneStr {
    //去掉特殊字符
    NSString *
    phoneNumber = [[[[[_phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""]
                      stringByReplacingOccurrencesOfString:@"-" withString:@""]
                     stringByReplacingOccurrencesOfString:@"(" withString:@""]
                    stringByReplacingOccurrencesOfString:@")" withString:@""]
                   stringByReplacingOccurrencesOfString:@"*" withString:@""];
    return phoneNumber;
}
@end
