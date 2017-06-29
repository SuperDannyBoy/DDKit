//
//  DDDropDownMenu.h
//  YanYou_Merchant
//
//  Created by SuperDanny on 16/4/28.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDDropDownMenu : UIView

- (void)showInView:(UIView *)view;
- (void)dismiss;
///刷新数据
- (void)reladData;
///设置行数
- (void)setRowBlock:(NSInteger(^)())block;
///设置点击事件
- (void)setSelectBlock:(void(^)(NSUInteger index))block;
///设置每一行的title
- (void)setTitleForRowAtIndexBlock:(NSString *(^)(NSUInteger index))block;

@end
