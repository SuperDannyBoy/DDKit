//
//  DDTextAlertView.m
//  YanYou_Merchant
//
//  Created by SuperDanny on 16/4/27.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "DDTextAlertView.h"

@implementation DDTextAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if (buttonIndex == 0) {
        [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    }
}

- (void)dismiss {
    [super dismissWithClickedButtonIndex:1 animated:YES];
}

@end
