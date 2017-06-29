//
//  ViewController.m
//  DDCustomKeyboard
//
//  Created by SuperDanny on 2017/6/28.
//  Copyright © 2017年 MacauIT. All rights reserved.
//

#import "ViewController.h"
#import "DDCustomKeyboard.h"

@interface ViewController () <DDCustomKeyboardDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DDCustomKeyboard *keyboard = [[DDCustomKeyboard alloc] initWithFrame:CGRectZero];
    keyboard.allowsDecimalPoint = YES;
    keyboard.delegate = self;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.inputView = keyboard;
    textField.text = @(123456789).stringValue;
    textField.placeholder = @"Type something…";
    textField.font = [UIFont systemFontOfSize:24.0f];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    textField.delegate = self;
    
    self.textField = textField;
    
    [self.view addSubview:textField];
}


#pragma mark - DDCustomKeyboardDelegate.

- (BOOL)numberKeyboardShouldReturn:(DDCustomKeyboard *)numberKeyboard {
    // Do something with the done key if neeed. Return YES to dismiss the keyboard.
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"xxxx");
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

#pragma mark - Layout.
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect bounds = (CGRect){
        .size = self.view.bounds.size
    };
    
    CGRect contentRect = UIEdgeInsetsInsetRect(bounds, (UIEdgeInsets){
        .top = self.topLayoutGuide.length,
        .bottom = self.bottomLayoutGuide.length,
    });
    
    const CGFloat pad = 20.0f;
    
    self.textField.frame = CGRectInset(contentRect, pad, pad);
}

#pragma mark - View events.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
