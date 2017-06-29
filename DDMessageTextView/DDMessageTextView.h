//
//  DDMessageTextView.h
//  YanYou_Merchant
//
//  Created by SuperDanny on 16/4/19.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMessageTextView : UIView

@property (strong, nonatomic) YYTextView *textView;

@property (copy, nonatomic) NSString *placeholder;
///字数限制
@property (assign, nonatomic) NSUInteger wordCount;

- (void)setWordCountExceedBlock:(void(^)(BOOL isExceed))block;

@end
