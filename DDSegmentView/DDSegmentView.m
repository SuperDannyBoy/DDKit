//
//  DDSegmentView.m
//  YanYou
//
//  Created by SuperDanny on 16/7/19.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "DDSegmentView.h"

#define kWBCellToolbarFontSize 14 // 工具栏字体大小
#define kWBCellToolbarHeight 40   // 工具栏高度
#define kWBCellToolbarTitleHighlightColor UIColorHex(1C85F3) // 工具栏文本高亮色
#define kWBCellToolbarTitleColor UIColorHex(929292) // 工具栏文本色
#define kWBCellHighlightColor UIColorHex(f0f0f0)     // Cell高亮时灰色
#define kWBCellLineColor [UIColor colorWithWhite:0.000 alpha:0.09] // 线条颜色
@interface DDSegmentView ()

@property (nonatomic, strong) ListModel *model;

@end

@implementation DDSegmentView

- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect frame = self.frame;
    frame.size.width = ScreenWidth;
    frame.size.height = kWBCellToolbarHeight;
    self.frame = frame;
    self.exclusiveTouch = YES;
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    
    [self setUp];
    
    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor whiteColor];
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.exclusiveTouch = YES;
    _shareButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height);
    [_shareButton setBackgroundImage:[UIImage imageWithColor:kWBCellHighlightColor] forState:UIControlStateHighlighted];
//    [_shareButton setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateNormal];
    [_shareButton setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateSelected];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.exclusiveTouch = YES;
    _commentButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height);
    _commentButton.left = CGFloatPixelRound(self.width / 3.0);
    [_commentButton setBackgroundImage:[UIImage imageWithColor:kWBCellHighlightColor] forState:UIControlStateHighlighted];
//    [_commentButton setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateNormal];
    [_commentButton setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateSelected];
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeButton.exclusiveTouch = YES;
    _likeButton.size = CGSizeMake(CGFloatPixelRound(self.width / 3.0), self.height);
    _likeButton.left = CGFloatPixelRound(self.width / 3.0 * 2.0);
    [_likeButton setBackgroundImage:[UIImage imageWithColor:kWBCellHighlightColor] forState:UIControlStateHighlighted];
//    [_likeButton setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateNormal];
    [_likeButton setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateSelected];
    
    UIColor *dark = [UIColor colorWithWhite:0 alpha:0.2];
    UIColor *clear = [UIColor colorWithWhite:0 alpha:0];
    NSArray *colors = @[(id)clear.CGColor,(id)dark.CGColor, (id)clear.CGColor];
    NSArray *locations = @[@0.2, @0.5, @0.8];
    
    _line1 = [CAGradientLayer layer];
    _line1.colors = colors;
    _line1.locations = locations;
    _line1.startPoint = CGPointMake(0, 0);
    _line1.endPoint = CGPointMake(0, 1);
    _line1.size = CGSizeMake(CGFloatFromPixel(1), self.height);
    _line1.left = _shareButton.right;
    
    _line2 = [CAGradientLayer layer];
    _line2.colors = colors;
    _line2.locations = locations;
    _line2.startPoint = CGPointMake(0, 0);
    _line2.endPoint = CGPointMake(0, 1);
    _line2.size = CGSizeMake(CGFloatFromPixel(1), self.height);
    _line2.left = _commentButton.right;
    
    _topLine = [CALayer layer];
    _topLine.size = CGSizeMake(self.width, CGFloatFromPixel(1));
    _topLine.backgroundColor = kWBCellLineColor.CGColor;
    
    _bottomLine = [CALayer layer];
    _bottomLine.size = _topLine.size;
    _bottomLine.bottom = self.height;
    _bottomLine.backgroundColor = UIColorHex(e8e8e8).CGColor;
    
    [self addSubview:_shareButton];
    [self addSubview:_commentButton];
    [self addSubview:_likeButton];
    [self.layer addSublayer:_line1];
    [self.layer addSublayer:_line2];
    [self.layer addSublayer:_topLine];
    [self.layer addSublayer:_bottomLine];
    
    @weakify(self);
    [_shareButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        [weak_self changeButtonStatus:weak_self.shareButton];
        if ([weak_self.delegate respondsToSelector:@selector(didClickShare)]) {
            [weak_self.delegate didClickShare];
        }
    }];
    
    [_commentButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        [weak_self changeButtonStatus:weak_self.commentButton];
        if ([weak_self.delegate respondsToSelector:@selector(didClickComment)]) {
            [weak_self.delegate didClickComment];
        }
    }];
    
    [_likeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        [weak_self changeButtonStatus:weak_self.likeButton];
        if ([weak_self.delegate respondsToSelector:@selector(didClickLike)]) {
            [weak_self.delegate didClickLike];
        }
    }];
}

- (void)changeButtonStatus:(UIButton *)btn {
    _shareButton.selected = _commentButton.selected = _likeButton.selected = NO;
    btn.selected = YES;
}

- (void)setWithModue:(ListModel *)modue SelectSegmentTypy:(DDSegmentViewType)segType {
    if (!modue) {
        return;
    }
    self.model = modue;
    [self layoutToolbar:segType];
}

- (void)layoutToolbar:(DDSegmentViewType)segType {
    // should be localized
    UIFont *font = [UIFont systemFontOfSize:kWBCellToolbarFontSize];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, kWBCellToolbarHeight)];
    container.maximumNumberOfRows = 1;
    
    NSMutableAttributedString *shareText = [[NSMutableAttributedString alloc] initWithString:[_model.share_num integerValue] <= 0 ? @"分享" : [NSString stringWithFormat:@"分享 %@", [DDSegmentView shortedNumberDesc:[_model.share_num integerValue]]]];
    shareText.font = font;
    shareText.color = kWBCellToolbarTitleColor;
    [_shareButton setAttributedTitle:shareText forState:UIControlStateNormal];
    
    NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[_model.reply_num integerValue] <= 0 ? @"评论" : [NSString stringWithFormat:@"评论 %@", [DDSegmentView shortedNumberDesc:[_model.reply_num integerValue]]]];
    commentText.font = font;
    commentText.color = kWBCellToolbarTitleColor;
    [_commentButton setAttributedTitle:commentText forState:UIControlStateNormal];
    
    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:[_model.like_num integerValue] <= 0 ? @"点赞" : [NSString stringWithFormat:@"点赞 %@", [DDSegmentView shortedNumberDesc:[_model.like_num integerValue]]]];
    likeText.font = font;
    likeText.color = kWBCellToolbarTitleColor;
    [_likeButton setAttributedTitle:likeText forState:UIControlStateNormal];
    
    switch (segType) {
        case DDSegmentViewType_Share: {
            [self changeButtonStatus:_shareButton];
            break;
        }
        case DDSegmentViewType_Comment: {
            [self changeButtonStatus:_commentButton];
            break;
        }
        case DDSegmentViewType_Zan: {
            [self changeButtonStatus:_likeButton];
            break;
        }
    }
}

/// 缩短数量描述，例如 51234 -> 5万
+ (NSString *)shortedNumberDesc:(NSUInteger)number {
    // should be localized
    if (number <= 9999) return [NSString stringWithFormat:@"%d", (int)number];
    if (number <= 9999999) return [NSString stringWithFormat:@"%d万", (int)(number / 10000)];
    return [NSString stringWithFormat:@"%d千万", (int)(number / 10000000)];
}

@end
