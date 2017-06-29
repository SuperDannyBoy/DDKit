//
//  DDCustomPickerView.m
//  YanYou
//
//  Created by SuperDanny on 16/9/12.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "DDCustomPickerView.h"

#import <QuartzCore/QuartzCore.h>

#define kDuration   0.3
#define kRowHeight  44.f
#define kSingleLineColor [UIColor colorWithRed:239/255. green:240/255. blue:241/255. alpha:1]

@interface DDCustomPickerView ()

@property (copy, nonatomic) void(^Select_Block)(NSInteger, NSInteger);
@property (copy, nonatomic) void(^Choose_Block)();
@property (copy, nonatomic) NSString *(^TitleForRow_Block)(NSInteger, NSInteger);
@property (copy, nonatomic) NSUInteger(^NumberOfRows_Block)(NSInteger);
///列数
@property (assign, nonatomic) DDPickerStyle pickerStyle;
@property (strong, nonatomic) UIView *bgView;

@end

@implementation DDCustomPickerView

- (instancetype)initWithStyle:(DDPickerStyle)pickerStyle {
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"DDCustomPickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.pickerView.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.frame)-40);
        self.pickerStyle = pickerStyle;
    }
    
    return self;
}

- (void)setSelectBlock:(void(^)(NSInteger row, NSInteger component))block {
    self.Select_Block = block;
}

- (void)setChooseBlock:(void(^)())block {
    self.Choose_Block = block;
}

- (void)setNumberOfRowsBlock:(NSUInteger(^)(NSInteger component))block {
    self.NumberOfRows_Block = block;
}

- (void)setTitleForRowBlock:(NSString *(^)(NSInteger row, NSInteger component))block {
    self.TitleForRow_Block = block;
}

#pragma mark - PickerView lifecycle
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (_pickerStyle) {
        case DDPickerStyle_1: {
            return 1;
            break;
        }
        case DDPickerStyle_2: {
            return 2;
            break;
        }
        case DDPickerStyle_3: {
            return 3;
            break;
        }
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_NumberOfRows_Block) {
        return _NumberOfRows_Block(component);
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    CGFloat componentWidth = 0.0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    switch (_pickerStyle) {
        case DDPickerStyle_1: {
            componentWidth = width;
            break;
        }
        case DDPickerStyle_2: {
            componentWidth = width/2.0;
            break;
        }
        case DDPickerStyle_3: {
            componentWidth = width/3.0;
            break;
        }
    }
    return componentWidth;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    //设置分割线的颜色
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = kSingleLineColor;
        }
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    UILabel *myView = [[UILabel alloc] init];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = _TitleForRow_Block(row, component);
    
    switch (_pickerStyle) {
        case DDPickerStyle_1: {
            myView.frame = CGRectMake(0.0, 0.0, width, kRowHeight);
            myView.font = [UIFont systemFontOfSize:20];//用label来设置字体大小
            break;
        }
        case DDPickerStyle_2: {
            myView.frame = CGRectMake(0.0, 0.0, width/2.0, kRowHeight);
            myView.font = [UIFont systemFontOfSize:16];//用label来设置字体大小
            break;
        }
        case DDPickerStyle_3: {
            myView.frame = CGRectMake(0.0, 0.0, width/3.0, kRowHeight);
            myView.font = [UIFont systemFontOfSize:14];//用label来设置字体大小
            break;
        }
    }
    return myView;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _TitleForRow_Block(row, component);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_Select_Block) {
        _Select_Block(row, component);
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return kRowHeight;
}

- (IBAction)choose {
    if (_Choose_Block) {
        _Choose_Block();
    }
    [self dismiss];
}

#pragma mark - animation
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
