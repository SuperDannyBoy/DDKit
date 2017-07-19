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

#pragma mark - 使用autolayout布局时，需要刷新约束才能获取到真实的frame
- (void)updateFrame {
    [self updateConstraints];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
