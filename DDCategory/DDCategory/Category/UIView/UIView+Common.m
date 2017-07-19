//
//  UIView+Common.m
//  DDCategory
//
//  Created by SuperDanny on 15/8/6.
//  Copyright © 2015年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "UIView+Common.h"
#import <objc/runtime.h>

@implementation UIView (Common)

static char BlankPageViewKey;

#pragma mark BlankPageView
- (void)setBlankPageView:(EaseBlankPageView *)blankPageView{
    [self willChangeValueForKey:@"BlankPageViewKey"];
    objc_setAssociatedObject(self, &BlankPageViewKey,
                             blankPageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankPageViewKey"];
}

- (EaseBlankPageView *)blankPageView{
    return objc_getAssociatedObject(self, &BlankPageViewKey);
}

- (void)configBlankPage:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block{
    if (hasData) {
        if (self.blankPageView) {
            self.blankPageView.hidden = YES;
            [self.blankPageView removeFromSuperview];
        }
    } else{
        if (!self.blankPageView) {
            self.blankPageView = [[EaseBlankPageView alloc] init];
        }
        self.blankPageView.hidden = NO;
        [self.blankPageContainer addSubview:self.blankPageView];
        self.blankPageView.frame = CGRectMake(0.0, 0.0, self.blankPageContainer.bounds.size.width,
                                              self.blankPageContainer.bounds.size.height);
        
        [self.blankPageView configWithType:blankPageType hasData:hasData hasError:hasError reloadButtonBlock:block];
    }
}

- (UIView *)blankPageContainer{
    UIView *blankPageContainer = self;
    for (UIView *aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]] || [aView isKindOfClass:[UICollectionView class]]) {
            blankPageContainer = aView;
        }
    }
    return blankPageContainer;
}

- (void)configRemoveInSuperView {
    self.blankPageView.hidden = YES;
    [self.blankPageView removeFromSuperview];
}

@end

@implementation EaseBlankPageView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configWithType:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_loadAndShowStatusBlock) {
            _loadAndShowStatusBlock();
        }
    });
    
    if (hasData) {
        [self removeFromSuperview];
        return;
    }
    self.alpha = 1.0;
    // 图片
    if (!_monkeyView) {
        _monkeyView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_monkeyView];
    }
    // 文字
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
    }
    
    // 布局
    CGRect imageRect = _monkeyView.frame;
    imageRect.size.height = imageRect.size.width = 98;
    imageRect.origin.x = (CGRectGetWidth(self.frame)-98)/2.0;
//    imageRect.origin.y = ((CGRectGetHeight(self.frame)-80-40)/2.0);
    imageRect.origin.y = MAX(self.center.y-(98+50)/2, ((CGRectGetHeight(self.frame)-98-50)/2.0));
    _monkeyView.frame = imageRect;
    
    _tipLabel.frame = CGRectMake(0, CGRectGetMaxY(_monkeyView.frame), CGRectGetWidth(self.frame), 50);
    
    _reloadButtonBlock = nil;
    if (hasError) {
        // 加载失败
        if (!_reloadButton) {
            _reloadButton = [[UIButton alloc] initWithFrame:CGRectZero];
            _reloadButton.exclusiveTouch = YES;
            _reloadButton.clipsToBounds = YES;
            _reloadButton.layer.cornerRadius = 8;
            [_reloadButton setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
            [_reloadButton setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]] forState:UIControlStateDisabled];
            [_reloadButton setTitle:NSLocalizedString(@"重試", nil) forState:UIControlStateNormal];
            [_reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _reloadButton.adjustsImageWhenHighlighted = YES;
            [_reloadButton addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_reloadButton];
            
            _reloadButton.frame = CGRectMake((CGRectGetWidth(self.frame)-160)/2.0, CGRectGetMaxY(_tipLabel.frame), 160, 40);
        }
        _reloadButton.hidden = NO;
        _reloadButtonBlock = block;
        [_monkeyView setImage:[UIImage imageNamed:@"网络断开"]];
        _tipLabel.text = NSLocalizedString(@"網絡錯誤\n請檢查您的網絡設定", nil);
    } else {
        // 空白数据
        if (_reloadButton) {
            _reloadButton.hidden = YES;
        }
        
        NSString *imageName, *tipStr;
        _curType=blankPageType;
        switch (blankPageType) {
            case EaseBlankPageTypeView_Default:
            {
                imageName = @"无数据";
                tipStr = NSLocalizedString(@"什麼都沒有~~\n空空如也", nil);
            }
                break;
            case EaseBlankPageTypeView_NoSearchData:
            {
                imageName = @"search";
                tipStr = NSLocalizedString(@"試著搜點什麼吧~~\n", nil);
                CGRect rect = _monkeyView.frame;
                rect.origin.y -= 150;
                _monkeyView.frame = rect;
                
                CGRect tipRect = _tipLabel.frame;
                tipRect.origin.y = CGRectGetMaxY(_monkeyView.frame);
                _tipLabel.frame = tipRect;
            }
                break;
            case EaseBlankPageTypeView_NoVIPCard:
            {
                imageName = @"card_novipcard";
                tipStr = NSLocalizedString(@"還沒有會員卡喲，點擊右上角“+”號\n領取會員卡，享受更多優惠哦！", nil);
            }
                break;
            default://其它页面
            {
                imageName = @"无数据";
                tipStr = NSLocalizedString(@"什麼都沒有~~\n空空如也", nil);
            }
                break;
        }
        [_monkeyView setImage:[UIImage imageNamed:imageName]];
        _tipLabel.text = tipStr;
    }
}

- (void)reloadButtonClicked:(id)sender{
    self.hidden = YES;
    [self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_reloadButtonBlock) {
            _reloadButtonBlock(sender);
        }
    });
}

@end
