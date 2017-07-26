//
//  UIView+Additional.h
//  DDCategory
//
//  Created by SuperDanny on 16/8/12.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DDViewBorder) {
    DDViewBorderTop    = 1<<1, ///< 顶部画线
    DDViewBorderLeft   = 1<<2, ///< 左边画线
    DDViewBorderBottom = 1<<3, ///< 底部画线
    DDViewBorderRight  = 1<<4, ///< 右边画线
};

@interface UIView (Additional)

@property (nonatomic, assign) DDViewBorder borderWhich;

@property (nonatomic) CGFloat dd_x;         ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat dd_y;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat dd_max_x;     ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat dd_max_y;     ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat dd_w;         ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat dd_h;         ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat dd_centerX;   ///< Shortcut for center.x
@property (nonatomic) CGFloat dd_centerY;   ///< Shortcut for center.y
@property (nonatomic) CGPoint dd_origin;    ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  dd_size;      ///< Shortcut for frame.size.

///加阴影效果
- (void)makeShadow;

/**
 指定圆角位置

 @code
 corners类型：
 
 typedef NS_OPTIONS(NSUInteger, UIRectCorner) {
 UIRectCornerTopLeft     = 1 << 0,
 UIRectCornerTopRight    = 1 << 1,
 UIRectCornerBottomLeft  = 1 << 2,
 UIRectCornerBottomRight = 1 << 3,
 UIRectCornerAllCorners  = ~0UL
 };
 @endcode
 
 @param cornerRadius 圆角半径(弧度)
 @param corners 圆角方向
 */
- (void)makeCornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)corners;

@end
