//
//  UITextField+UI.m
//  DDCategory
//
//  Created by SuperDanny on 15/8/6.
//  Copyright © 2015年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "UITextField+UI.h"
#import "IonIcons.h"

@implementation UITextField (UI)

- (void)setDiyClearButton {
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    //获取clearButton 并更改颜色（frame = (-24 -10; 19 19);）
    UIButton *clearButton = [self valueForKeyPath:@"clearButton"];
    //获取系统原始图片
    //<UIImage: 0x17de3a50>, {14, 14}
    //UIImage *originalImage = [clearButton imageForState:UIControlStateNormal];
    UIImage *img_nor = [IonIcons imageWithIcon:ion_close_circled size:19 color:[UIColor grayColor]];
    UIImage *img_sel = [IonIcons imageWithIcon:ion_close_circled size:19 color:[UIColor grayColor]];

    [clearButton setImage:img_nor forState:UIControlStateNormal];
    [clearButton setImage:img_sel forState:UIControlStateSelected];
}

@end
