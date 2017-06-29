//
//  DDPageItem.m
//  BannerView
//
//  Created by SuperDanny on 16/1/22.
//  Copyright © 2016年 SuperDanny. All rights reserved.
//

#import "DDPageItem.h"

@implementation DDPageItem

- (id)initWithTitle:(NSString *)title image:(NSString *)imageURL {
    if (self = [super init]) {
        self.title    = title;
        self.imageURL = imageURL;
    }
    return self;
}

- (id)initWithDict:(NSDictionary *)dict tag:(NSUInteger)tag {
    if (self = [super init]) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.title    = [dict objectForKey:kItemInfoKey_Title];
            self.imageURL = [dict objectForKey:kItemInfoKey_URL];
            self.tag      = tag;
            //...
        }
    }
    return self;
}
@end
