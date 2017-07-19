//
//  UIView+Additional.m
//  DDCategory
//
//  Created by SuperDanny on 16/8/12.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "UIView+Additional.h"

@implementation UIView (Additional)
@dynamic borderWhich;

#pragma mark - 局部分割线功能
- (void)setBorderWhich:(DDViewBorder)borderWhich {
    CGFloat bh = self.layer.borderWidth;
    
    if (borderWhich & DDViewBorderBottom) {
        [self addBottomBorder:self borderHeight:bh];
    }
    if (borderWhich & DDViewBorderLeft) {
        [self addLeftBorder:self borderHeight:bh];
    }
    if (borderWhich & DDViewBorderRight) {
        [self addRightBorder:self borderHeight:bh];
    }
    if (borderWhich & DDViewBorderTop) {
        [self addTopBorder:self borderHeight:bh];
    }
    self.layer.borderWidth = 0;
}

- (void)addTopBorder:(UIView *)vi borderHeight:(CGFloat)bh {
    CGColorRef col = vi.layer.borderColor;
    if (vi.layer.borderWidth > 1000 || vi.layer.borderWidth == 0) {
        bh = 0.5;
    }
    else
        bh = vi.layer.borderWidth;
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 0, vi.frame.size.width, bh);
    border.backgroundColor = col;
    border.name = @"top";
    [vi.layer addSublayer:border];
}

- (void)addLeftBorder:(UIView *)vi borderHeight:(CGFloat)bh{
    CGColorRef col = vi.layer.borderColor;
    if (vi.layer.borderWidth > 1000 || vi.layer.borderWidth == 0) {
        bh = 0.5;
    }
    else
        bh = vi.layer.borderWidth;
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 0, bh, vi.frame.size.height);
    border.backgroundColor = col;
    [vi.layer addSublayer:border];
}

- (void)addBottomBorder:(UIView *)vi borderHeight:(CGFloat)bh{
    CGColorRef col = vi.layer.borderColor;
    if (vi.layer.borderWidth > 1000 || vi.layer.borderWidth == 0) {
        bh = 0.5;
    }
    else
        bh = vi.layer.borderWidth;
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, vi.frame.size.height-bh, vi.frame.size.width, bh);
    border.backgroundColor = col;
    border.name = @"bottom";
    [vi.layer addSublayer:border];
}

- (void)addRightBorder:(UIView *)vi borderHeight:(CGFloat)bh{
    CGColorRef col = vi.layer.borderColor;
    if (vi.layer.borderWidth > 1000 || vi.layer.borderWidth == 0) {
        bh = 0.5;
    }
    else
        bh = vi.layer.borderWidth;
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(vi.frame.size.width-bh, 0, bh, vi.frame.size.height);
    border.backgroundColor = col;
    [vi.layer addSublayer:border];
}

#pragma mark - 阴影功能
- (void)makeShadow {
    /*
     注意：
     1、当阴影和裁剪扯上关系的时候就有一个头疼的限制：阴影通常就是在Layer的边界之外，如果你开启了masksToBounds属性，所有从图层中突出来的内容都会被才剪掉。换句话说，当有设置圆角时，阴影会失效。因为masksToBounds属性对frame外的内容进行了裁减，只可显示frame内的内容。由于这种方法加的阴影在frame外，所以被裁减了。
     2、从技术角度来说，这个结果是可以理解的，但确实又不是我们想要的效果。如果你想沿着内容裁切，你需要用到两个图层：一个只画阴影的空的外图层，和一个用masksToBounds裁剪内容的内图层
     */
    //阴影的颜色
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    //阴影的透明度
    self.layer.shadowOpacity = 0.45f;
    //阴影的圆角
    self.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.layer.shadowOffset = CGSizeMake(0,2);
}

#pragma mark 使用autolayout布局时，需要刷新约束才能获取到真实的frame
- (void)updateFrame {
    [self updateConstraints];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - 快速获取frame功能
- (CGFloat)dd_x {
    return CGRectGetMinX(self.frame);
}

- (void)setDd_x:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)dd_y {
    return CGRectGetMinY(self.frame);
}

- (void)setDd_y:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)dd_max_x {
    return CGRectGetMaxX(self.frame);
}

- (void)setDd_max_x:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)dd_max_y {
    return CGRectGetMaxY(self.frame);
}

- (void)setDd_max_y:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)dd_w {
    return CGRectGetWidth(self.frame);
}

- (void)setDd_w:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)dd_h {
    return CGRectGetHeight(self.frame);
}

- (void)setDd_h:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)dd_centerX {
    return CGRectGetMidX(self.frame);
}

- (void)setDd_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)dd_centerY {
    return CGRectGetMidY(self.frame);
}

- (void)setDd_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)dd_origin {
    return self.frame.origin;
}

- (void)setDd_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)dd_size {
    return self.frame.size;
}

- (void)setDd_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
