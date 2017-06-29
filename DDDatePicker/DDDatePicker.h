//
//  DDDatePicker.h
//  YanYou_Merchant
//
//  Created by SuperDanny on 16/5/5.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDDatePicker : UIView

///比较两个日期大小
+ (BOOL)compareDateA:(NSDate *)dateA isBiggerThanDateB:(NSDate *)dateB;

- (instancetype)initWithDateMode:(UIDatePickerMode)mode;
///设置显示日期
- (void)setDate:(NSDate *)date;
///设置最大日期
- (void)setMaximumDateDate:(NSDate *)date;
- (void)setChooseDateBlock:(void(^)(NSString *timeStr))block;
- (void)showInView:(UIView *)view;
- (IBAction)dismiss;

@end
