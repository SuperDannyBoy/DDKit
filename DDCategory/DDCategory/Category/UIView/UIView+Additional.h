//
//  UIView+Additional.h
//  DDCategory
//
//  Created by SuperDanny on 16/8/12.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZJViewBorder) {
    ZJViewBorderTop    = 1<<1,
    ZJViewBorderLeft   = 1<<2,
    ZJViewBorderBottom = 1<<3,
    ZJViewBorderRight  = 1<<4,
};

@interface UIView (Additional)

@property (nonatomic, assign) ZJViewBorder borderWhich;

///加阴影效果
- (void)makeShadow;

@end
