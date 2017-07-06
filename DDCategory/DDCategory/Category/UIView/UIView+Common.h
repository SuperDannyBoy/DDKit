//
//  UIView+Common.h
//
//  Created by SuperDanny on 15/12/11.
//  Copyright © 2015年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>

@class EaseBlankPageView;

typedef NS_ENUM(NSInteger, EaseBlankPageType) {
    ///
    EaseBlankPageTypeView_Default = 0,
    ///搜索界面_无结果
    EaseBlankPageTypeView_NoSearchData,
    ///會員匯_无虚拟卡（会员卡）
    EaseBlankPageTypeView_NoVIPCard
};

@interface UIView (Common)

#pragma mark BlankPageView
@property (strong, nonatomic) EaseBlankPageView *blankPageView;
/**
 *  数据空时,在页面上显示点儿啥
 *  @param blankPageType : 类型
 *  @param hasData : YES->remove EaseBlankPageView (其他参数全部没用)  NO-> 判断 hasError 来显示页面
 *  @param hasError : YES->request fail,click reload button perform block to refresh data . NO->请求成功,根据 hasData 来显示页面
 *  @param block " 当 hasError 为 YES 时 ,重新加载数据的函数块
 */
- (void)configBlankPage:(EaseBlankPageType)blankPageType
                hasData:(BOOL)hasData
               hasError:(BOOL)hasError
      reloadButtonBlock:(void(^)(id sender))block;

/**
 删除提示图标
 */
-(void)configRemoveInSuperView;
@end

@interface EaseBlankPageView : UIView
@property (strong, nonatomic) UIImageView *monkeyView;
@property (strong, nonatomic) UILabel     *tipLabel;
@property (strong, nonatomic) UIButton    *reloadButton;
@property (assign, nonatomic) EaseBlankPageType curType;
@property (copy, nonatomic) void(^reloadButtonBlock)(id sender);
@property (copy, nonatomic) void(^loadAndShowStatusBlock)();
@property (copy, nonatomic) void(^clickButtonBlock)(EaseBlankPageType curType);
- (void)configWithType:(EaseBlankPageType)blankPageType
               hasData:(BOOL)hasData
              hasError:(BOOL)hasError
     reloadButtonBlock:(void(^)(id sender))block;


@end
