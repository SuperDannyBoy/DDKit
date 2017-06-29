//
//  DDMessageTextView.m
//  YanYou_Merchant
//
//  Created by SuperDanny on 16/4/19.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "DDMessageTextView.h"

@interface DDMessageTextView () <YYTextViewDelegate>

///字数限制
@property (strong, nonatomic) UILabel    *limitsLab;

@property (assign, nonatomic) NSUInteger limitCount;

@property (copy, nonatomic) void(^WordCountExceed_Block)(BOOL);

@end

@implementation DDMessageTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _textView           = [YYTextView new];
    _textView.font      = [UIFont systemFontOfSize:16];
    _textView.textColor = [UIColor colorWithWhite:0.133 alpha:1.000];
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.delegate  = self;
    [self addSubview:_textView];
    
    _limitsLab = [UILabel new];
    _limitsLab.textColor = [UIColor colorWithWhite:0.816 alpha:1.000];
    _limitsLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_limitsLab];
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorFromHexWithAlpha(0xD0D0D0, 0.7);
    //    [self addSubview:line];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
        make.top.equalTo(self).offset(8);
    }];
    
    [_limitsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@21);
        make.left.equalTo(self).offset(18);
        make.right.equalTo(self).offset(-18);
        make.top.equalTo(_textView.mas_bottom).offset(4);
        make.bottom.equalTo(self).offset(-30);
    }];
    
    //    [line mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.equalTo(@1);
    //        make.left.equalTo(self).offset(5);
    //        make.right.equalTo(self).offset(-5);
    //        make.top.equalTo(_limitsLab.mas_bottom).offset(10);
    //    }];
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (placeholder.length) {
        _textView.placeholderText = placeholder;
        return;
    }
    _textView.placeholderText = @"";
}

- (void)setWordCount:(NSUInteger)wordCount {
    if (!wordCount || wordCount == 0) {
        _limitsLab.hidden = YES;
        return;
    }
    _limitsLab.hidden = NO;
    self.limitCount = wordCount;
    _limitsLab.text = [NSString stringWithFormat:@"0/%@", @(wordCount)];
}

- (void)setWordCountExceedBlock:(void (^)(BOOL))block {
    self.WordCountExceed_Block = block;
}

#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    NSUInteger remainTextNum = _limitCount;
    
    NSString *nsTextContent = textView.text;
    NSUInteger existTextNum = [nsTextContent length];
    remainTextNum = _limitCount - existTextNum;
    
    _limitsLab.text = [NSString stringWithFormat:@"%@/%@", @(existTextNum), @(_limitCount)];
    
    //字数是否超过规定限制
    BOOL isExceed = NO;
    //如果超过限制字数，则显示红色
    if (existTextNum > _limitCount) {
        isExceed = YES;
        _limitsLab.textColor = [UIColor colorWithRed:0.875 green:0.216 blue:0.176 alpha:1.000];
    } else {
        isExceed = NO;
        _limitsLab.textColor = [UIColor colorWithWhite:0.816 alpha:1.000];
    }
    
    if (_WordCountExceed_Block) {
        _WordCountExceed_Block(isExceed);
    }
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) { //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];//关闭键盘
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

@end
