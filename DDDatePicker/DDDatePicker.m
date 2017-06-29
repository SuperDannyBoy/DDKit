//
//  DDDatePicker.m
//  YanYou_Merchant
//
//  Created by SuperDanny on 16/5/5.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "DDDatePicker.h"

@interface DDDatePicker ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (copy, nonatomic) void(^Choose_DateBlock)(NSString *);
@property (strong, nonatomic) NSDate *selectDate;
@property (strong, nonatomic) NSDate *showDate;
@property (strong, nonatomic) UIView *bgView;

@end

@implementation DDDatePicker

- (instancetype)initWithDateMode:(UIDatePickerMode)mode {
    self = [[[NSBundle mainBundle] loadNibNamed:@"DDDatePicker" owner:self options:nil] objectAtIndex:0];;
    if (self) {
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        _datePicker.datePickerMode = mode;
    }
    return self;
}

#pragma mark - 比较两个日期大小
+ (BOOL)compareDateA:(NSDate *)dateA isBiggerThanDateB:(NSDate *)dateB {
    if ([dateA compare:dateB] == NSOrderedAscending) {
        return NO;
    }
    return YES;
}

#pragma mark - 设置显示日期
- (void)setDate:(NSDate *)date {
    _showDate = date;
    ///如果最大数小于指定显示日期，则显示最大数
    if ([_datePicker.maximumDate compare:date] == NSOrderedAscending) {
        _showDate = _datePicker.maximumDate;
    }
    [_datePicker setDate:_showDate animated:YES];
    _selectDate = _showDate;
}

#pragma mark - 设置最大日期
- (void)setMaximumDateDate:(NSDate *)date {
    _datePicker.maximumDate = date;
    if (_showDate) {
        [self setDate:_showDate];
    } else {
        _selectDate = date;
    }
}

- (void)dateChanged:(UIDatePicker *)sender {
    _selectDate = sender.date;
}

- (void)setChooseDateBlock:(void (^)(NSString *))block {
    self.Choose_DateBlock = block;
}

- (IBAction)chooseDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:_selectDate];
    if (_Choose_DateBlock) {
        _Choose_DateBlock(str);
    }
    [self dismiss];
}

- (void)showInView:(UIView *)view {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _bgView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.337];
    [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    [_bgView addSubview:self];
    [view addSubview:_bgView];
    
    self.frame = CGRectMake(0, view.frame.size.height, screenWidth, self.frame.size.height);
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.frame = CGRectMake(0, view.frame.size.height - weakSelf.frame.size.height, screenWidth, weakSelf.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)dismiss {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         weakSelf.frame = CGRectMake(0, weakSelf.frame.origin.y+weakSelf.frame.size.height, screenWidth, weakSelf.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [weakSelf removeFromSuperview];
                         [_bgView removeFromSuperview];
                     }];
}

@end
