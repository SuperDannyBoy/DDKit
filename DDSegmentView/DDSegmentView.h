//
//  DDSegmentView.h
//  YanYou
//
//  Created by SuperDanny on 16/7/19.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"

typedef NS_ENUM(NSUInteger, DDSegmentViewType) {
    ///分享
    DDSegmentViewType_Share,
    ///评论
    DDSegmentViewType_Comment,
    ///点赞
    DDSegmentViewType_Zan,
};

@protocol DDSegmentViewDelegate <NSObject>

///点击了分享
- (void)didClickShare;
///点击了评论
- (void)didClickComment;
///点击了点赞
- (void)didClickLike;

@end

@interface DDSegmentView : UIView

@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) YYLabel *shareLabel;
@property (nonatomic, strong) YYLabel *commentLabel;
@property (nonatomic, strong) YYLabel *likeLabel;

@property (nonatomic, strong) CAGradientLayer *line1;
@property (nonatomic, strong) CAGradientLayer *line2;
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, strong) id<DDSegmentViewDelegate> delegate;

- (void)setWithModue:(ListModel *)modue SelectSegmentTypy:(DDSegmentViewType)segType;
/// 缩短数量描述，例如 51234 -> 5万
+ (NSString *)shortedNumberDesc:(NSUInteger)number;

@end
