//
//  DDCarouselView.h
//  DDCarouselView
//
//  Created by SuperDanny on 2017/7/24.
//  Copyright © 2017年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCarouselViewRenderDelegate.h"

///将builder的minimumLineSpacing设置为该值则会自动计算合适的间距
#define kDDBuilderLineSpacingAuto -10001

typedef NS_ENUM(NSInteger,DDCarouselViewScrollDirection) {
    DDCarouselViewScrollDirectionRight = 0,
    DDCarouselViewScrollDirectionLeft,
    DDCarouselViewScrollDirectionBotom,
    DDCarouselViewScrollDirectionTop,
};

@interface DDCarouselViewBuilder : NSObject
#pragma mark - 必要参数
/**
 *   必填：广告模型数组
 */
@property (nonatomic, strong) NSArray *adArray;
/**
 *   view frame
 */
@property (nonatomic, assign) CGRect viewFrame;
/**
 *   广告的大小
 */
@property (nonatomic, assign) CGSize adItemSize;
/**
 *   最小行间距
 */
@property (nonatomic, assign) CGFloat minimumLineSpacing;
/**
 *  非当前广告的alpha值 如果不需要，填负数
 */
@property (nonatomic, assign) CGFloat secondaryItemMinAlpha;
/**
 *   adItem 的 nib   (与itemCellClassName只能二选一)
 */
@property (nonatomic, strong) NSString *itemCellNibName;
/**
 *   adItem 的 Class (与itemCellNibName只能二选一)
 */
@property (nonatomic, strong) NSString *itemCellClassName;
/**
 *   是否允许拖拽
 */
@property (nonatomic, assign) BOOL scrollEnabled;

#pragma mark - 非必要参数，有默认值
/**
 *   轮播间隔
 */
@property (nonatomic, assign) NSTimeInterval infiniteCycle;
/**
 *   scroll direction 轮播的方向 默认为向右
 */
@property (nonatomic, assign) DDCarouselViewScrollDirection autoScrollDirection;
/**
 *   item最小间距
 */
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
/**
 *   3D缩放值，若为0，则为2D广告
 */
@property (nonatomic, assign) CGFloat threeDimensionalScale;
/**
 *   循环轮播 默认为YES
 */
@property (nonatomic, assign) BOOL allowedInfinite;

@end

@protocol DDCarouselViewRenderDelegate;

@protocol DDCarouselViewDelegate <NSObject>
/**
 *  @brief 滑动到的广告的index
 */
- (void)dd_scrollToIndex:(NSInteger)index;
/**
 *  @brief 点击了广告，返回广告信息
 */
- (void)dd_didClickAd:(id)adModel;

@end

@interface DDCarouselView : UIView

@property (nonatomic, weak) id<DDCarouselViewDelegate>delegate;
/**
 *  @brief 构造方法
 *  @param builderBlock 通过在block中配置builder中的参数来实现对广告view的不同设置
 *  @return DDCarouselView
 */
- (instancetype)initWithBuilder:(void (^) (DDCarouselViewBuilder *builder))builderBlock;
/**
 *  @brief 开始播放
 */
- (void)play;
/**
 *  @brief 停止播放
 */
- (void)pause;
/**
 *  @brief 刷新内容
 *  @param adArray 内容数组
 */
- (void)reloadWithDataArray:(NSArray *)adArray;

@end
