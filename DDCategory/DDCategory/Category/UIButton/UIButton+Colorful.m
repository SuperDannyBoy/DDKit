//
//  UIButton+Colorful.m
//  DDCategory
//
//  Created by SuperDanny on 15/8/6.
//  Copyright © 2015年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "UIButton+Colorful.h"

@implementation UIButton (Colorful)

- (void)makeColorfulArray:(NSArray *)colorArray colorfulType:(ColorfulType)colorfulType {
    UIImage *backImage = [self buttonImageFromColors:colorArray colorfulType:colorfulType];
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;
}

- (UIImage *)buttonImageFromColors:(NSArray *)colors colorfulType:(ColorfulType)colorfulType {
    NSMutableArray *ar = [NSMutableArray array];
    for (UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    [self updateFrame];
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (colorfulType) {
        case ColorfulType_TopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, CGRectGetHeight(self.frame));
            break;
        case ColorfulType_LeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(CGRectGetWidth(self.frame), 0.0);
            break;
        case ColorfulType_UpLeftToLowRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            break;
        case ColorfulType_UpRightToLowLeft:
            start = CGPointMake(CGRectGetWidth(self.frame), 0.0);
            end = CGPointMake(0.0, CGRectGetHeight(self.frame));
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 使用autolayout布局时，需要刷新约束才能获取到真实的frame
- (void)updateFrame {
    [self updateConstraints];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
