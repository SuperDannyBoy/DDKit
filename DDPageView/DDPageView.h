//
//  DDPageView.h
//  BannerView
//
//  Created by SuperDanny on 16/1/22.
//  Copyright © 2016年 SuperDanny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageItem.h"

@class DDPageView;

#pragma mark - DDPageViewDelegate
@protocol DDPageViewDelegate <NSObject>

@optional
- (void)foucusView:(DDPageView *)pageView didSelectItem:(DDPageItem *)item index:(NSInteger)index;
- (void)foucusView:(DDPageView *)pageView currentItem:(NSInteger)index;

@end

typedef void (^DDNoneDataCallBack)(void);

@interface DDPageView : UIView

/**
 *  NS_REQUIRES_NIL_TERMINATION
 *  time -> 滑动间隔
 *  showTitle -> 是否显示标题
 */
- (void)setViewFrame:(CGRect)frame
            delegate:(id<DDPageViewDelegate>)delegate
        timeInterval:(NSTimeInterval)time
         contentMode:(UIViewContentMode)contentMode
    placeholderImage:(NSString *)placeholderImage
     focusImageItems:(DDPageItem *)items, ... NS_REQUIRES_NIL_TERMINATION;
/**
 *  time -> 滑动间隔
 *  showTitle -> 是否显示标题
 */
- (void)setViewFrame:(CGRect)frame
            delegate:(id<DDPageViewDelegate>)delegate
        timeInterval:(NSTimeInterval)time
         contentMode:(UIViewContentMode)contentMode
    placeholderImage:(NSString *)placeholderImage
          imageArray:(NSArray *)array;

///是否显示标题
- (void)setViewFrame:(CGRect)frame
            delegate:(id<DDPageViewDelegate>)delegate
        timeInterval:(NSTimeInterval)time
         contentMode:(UIViewContentMode)contentMode
    placeholderImage:(NSString *)placeholderImage
          imageArray:(NSArray *)array
           showTitle:(BOOL)isShow;

- (void)scrollToIndex:(NSInteger)aIndex;
///销毁定时器
- (void)stopTimer;
///刷新数据
- (void)reloadData:(NSArray *)array;
///没有数据时点击默认图的回调
- (void)setDDNoneDataCallback:(DDNoneDataCallBack)block;

@property (nonatomic) id<DDPageViewDelegate> delegate;
///轮播图背景颜色
@property (nonatomic, strong) UIColor *pageBackgroundColor;

@end

