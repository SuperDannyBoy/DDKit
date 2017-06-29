//
//  DDButton.m
//  YanYou_Merchant
//
//  Created by SuperDanny on 16/5/26.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "DDButton.h"

@implementation DDButton

- (void)awakeFromNib {
    [self configureBackgroundImage];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureBackgroundImage];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self configureBackgroundImage];
    }
    return self;
}

- (void)configureBackgroundImage {
//    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.639 alpha:1.000]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.141 green:0.404 blue:0.651 alpha:1.000]] forState:UIControlStateHighlighted];
}

@end
