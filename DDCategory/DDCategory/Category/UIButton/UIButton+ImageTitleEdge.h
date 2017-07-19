//
//  UIButton+ImageTitleEdge.h
//  DDCategory
//
//  Created by SuperDanny on 15/8/6.
//  Copyright © 2015年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    ///图片左边,文字右边
    MKButtonEdgeInsetsStyleLeft,
    ///图片下面,文字上面
    MKButtonEdgeInsetsStyleBottom,
    ///图片右边,文字左边
    MKButtonEdgeInsetsStyleRight,
    ///图片上面,文字下面
    MKButtonEdgeInsetsStyleTop
};
@interface UIButton (ImageTitleEdge)
/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;
@end
