//
//  CollectionViewCell.m
//  DDCarouselView
//
//  Created by SuperDanny on 2017/7/24.
//  Copyright © 2017年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "CollectionViewCell.h"
#import "AdModel.h"

@implementation CollectionViewCell

- (void)setModel:(id)model {
    
    if ([model isKindOfClass:[AdModel class]]) {
        AdModel *h_model = model;
        _showImage.image = [UIImage imageNamed:h_model.imageName];
        _titleLabel.text = h_model.introduction;
    } else {
        NSString *imageName = model;
        _showImage.image = [UIImage imageNamed:imageName];
        _titleLabel.text = @"";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _showImage.layer.masksToBounds = YES;
//    _showImage.layer.cornerRadius = 8;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 8;
//    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.bgView.layer.shadowOpacity = 0.8;
//    self.bgView.layer.shadowRadius = 6.0f;
//    self.bgView.layer.shadowOffset = CGSizeMake(6, 6);
//    self.clipsToBounds = NO;
//    self.bgView.clipsToBounds = NO;
}

@end
