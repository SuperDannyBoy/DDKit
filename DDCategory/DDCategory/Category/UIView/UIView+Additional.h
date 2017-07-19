//
//  UIView+Additional.h
//  DDCategory
//
//  Created by SuperDanny on 16/8/12.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DDViewBorder) {
    DDViewBorderTop    = 1<<1,
    DDViewBorderLeft   = 1<<2,
    DDViewBorderBottom = 1<<3,
    DDViewBorderRight  = 1<<4,
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

@end
