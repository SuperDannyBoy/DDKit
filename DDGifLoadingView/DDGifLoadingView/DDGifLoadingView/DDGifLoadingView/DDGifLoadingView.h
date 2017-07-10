//
//  DDGifLoadingView.h
//  DDGifLoadingView
//
//  Created by SuperDanny on 16/4/1.
//  Copyright © 2016年 SuperDanny. All rights reserved.

#import <UIKit/UIKit.h>

@interface DDGifLoadingView : UIView

+ (void)show;
+ (void)showWithOverlay;

+ (void)dismiss;
+ (void)setTapDismissBlock:(void(^)())block;

+ (void)setGifWithImages:(NSArray *)images;
+ (void)setGifWithImageName:(NSString *)imageName;
+ (void)setGifWithURL:(NSURL *)gifUrl;

@end
