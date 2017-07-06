//
//  ViewController.m
//  DDCategory
//
//  Created by SuperDanny on 2017/6/29.
//  Copyright © 2017年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.font = [UIFont systemFontOfSize:24.0f];
    self.textView = textView;
    
    [self.view addSubview:textView];
    
    //测试金额转大写
    [self textDigitUppercaseWithMoney];
    //测试唯一标示
    [self textUUID];
}

- (void)textDigitUppercaseWithMoney {
    
    NSArray *temp = @[[NSString digitUppercaseWithMoney:@"0.0"],
                      [NSString digitUppercaseWithMoney:@"0.00"],
                      [NSString digitUppercaseWithMoney:@"0"],
                      [NSString digitUppercaseWithMoney:@"0."],
                      [NSString digitUppercaseWithMoney:@"."],
                      [NSString digitUppercaseWithMoney:@".12"],
                      [NSString digitUppercaseWithMoney:@"0.12"],
                      [NSString digitUppercaseWithMoney:@"12.00"],
                      [NSString digitUppercaseWithMoney:@"12.01"],
                      [NSString digitUppercaseWithMoney:@"12.10"],
                      [NSString digitUppercaseWithMoney:@"102.2"],
                      [NSString digitUppercaseWithMoney:@"102."],
                      [NSString digitUppercaseWithMoney:@"1#2..0.0"],
                      [NSString digitUppercaseWithMoney:@"12..0.0"],];
    
    NSMutableString *tempStr = [NSMutableString string];
    
    [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempStr appendString:obj];
        [tempStr appendString:@"\n"];
    }];
    
    _textView.text = tempStr;
}

- (void)textUUID {
    NSLog(@"UUID---%@", [NSString deviceID]);
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
    
    self.textView.frame = CGRectInset(contentRect, pad, pad);
}

#pragma mark - View events.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
