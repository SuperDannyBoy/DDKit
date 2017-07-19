//
//  UIButton+Colorful.h
//  DDCategory
//
//  Created by SuperDanny on 15/8/6.
//  Copyright © 2015年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ColorfulType) {
    ///从上到下
    ColorfulType_TopToBottom,
    ///从左到右
    ColorfulType_LeftToRight,
    ///从左上到右下
    ColorfulType_UpLeftToLowRight,
    ///从右上到左下
    ColorfulType_UpRightToLowLeft
};

@interface UIButton (Colorful)

///渐变色值
- (void)makeColorfulArray:(NSArray *)colorArray colorfulType:(ColorfulType)colorfulType;

@end
