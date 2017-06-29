//
//  DDGenderPickerView.h
//  YanYou
//
//  Created by SuperDanny on 16/6/27.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDGenderPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *genderPicker;

- (id)initWithSelectBlock:(void(^)(NSString *title, NSUInteger row))block;
- (void)showInView:(UIView *)view;
- (IBAction)cancelPicker;

@end
