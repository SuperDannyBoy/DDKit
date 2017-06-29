//
//  DDGenderPickerView.m
//  YanYou
//
//  Created by SuperDanny on 16/6/27.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "DDGenderPickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.3

@interface DDGenderPickerView ()

@property (copy, nonatomic) void(^Select_Block)(NSString *, NSUInteger);
@property (strong, nonatomic) UIView   *bgView;
@property (copy, nonatomic  ) NSString *genderStr;
@property (assign, nonatomic) NSUInteger selectRow;

@end

@implementation DDGenderPickerView

- (void)dealloc {
    self.Select_Block = nil;
}

- (id)initWithSelectBlock:(void(^)(NSString *title, NSUInteger row))block {
    self = [[[NSBundle mainBundle] loadNibNamed:@"DDGenderPickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.Select_Block = block;
        self.genderPicker.dataSource = self;
        self.genderPicker.delegate   = self;
    }
    
    return self;
}

#pragma mark - PickerView lifecycle
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *tempArr = @[@"男", @"女"];
    return tempArr.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *tempArr = @[@"男", @"女"];
    return tempArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *tempArr = @[@"男", @"女"];
    _genderStr = tempArr[row];
    _selectRow = row;
}

#pragma mark - animation
- (void)showInView:(UIView *)view {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _bgView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.337];
    [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker)]];
    [_bgView addSubview:self];
    [view addSubview:_bgView];
    
    self.frame = CGRectMake(0, view.frame.size.height, screenWidth, self.frame.size.height);
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.frame = CGRectMake(0, view.frame.size.height - weakSelf.frame.size.height, screenWidth, weakSelf.frame.size.height);
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)selectGender {
    if(_Select_Block) {
        _Select_Block(_genderStr, _selectRow);
    }
    [self cancelPicker];
}

- (IBAction)cancelPicker {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         weakSelf.frame = CGRectMake(0, weakSelf.frame.origin.y+weakSelf.frame.size.height, screenWidth, weakSelf.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [weakSelf removeFromSuperview];
                         [weakSelf.bgView removeFromSuperview];
                     }];
}

@end
