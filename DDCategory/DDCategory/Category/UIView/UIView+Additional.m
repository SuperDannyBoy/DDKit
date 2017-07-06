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

- (void)setBorderWhich:(ZJViewBorder)borderWhich {
    CGFloat bh = self.layer.borderWidth;
    
    if (borderWhich & ZJViewBorderBottom) {
        [self addBottomBorder:self borderHeight:bh];
    }
    if (borderWhich & ZJViewBorderLeft) {
        [self addLeftBorder:self borderHeight:bh];
    }
    if (borderWhich & ZJViewBorderRight) {
        [self addRightBorder:self borderHeight:bh];
    }
    if (borderWhich & ZJViewBorderTop) {
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

@end
