//
//  DDAlertController.m
//
//  Created by SuperDanny on 2017/1/5.
//  Copyright © 2017年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "DDAlertController.h"
#import <objc/runtime.h>

@implementation DDAlertAction

//按钮标题的字体颜色
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertAction class], &count);
    for(int i =0;i < count;i ++) {
        
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        
        if ([ivarName isEqualToString:@"_titleTextColor"]) {
            
            [self setValue:textColor forKey:@"titleTextColor"];
        }
    }
}

@end

@interface DDAlertController ()

@end

@implementation DDAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertController class], &count);
    for(int i = 0;i < count;i ++) {
        
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        
        //标题颜色
        if ([ivarName isEqualToString:@"_attributedTitle"] && self.title && self.titleColor) {
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.title attributes:@{NSForegroundColorAttributeName:self.titleColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0]}];
            [self setValue:attr forKey:@"attributedTitle"];
        }
        
        //描述颜色
        if ([ivarName isEqualToString:@"_attributedMessage"] && self.message && self.messageColor) {
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.message attributes:@{NSForegroundColorAttributeName:self.messageColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
            [self setValue:attr forKey:@"attributedMessage"];
        }
    }
    
    //按钮统一颜色
    if (self.tintColor) {
        for (DDAlertAction *action in self.actions) {
            if (!action.textColor) {
                action.textColor = self.tintColor;
            }
        }
    }
}

@end
