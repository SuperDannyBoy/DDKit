//
//  CollectionViewCell.h
//  DDCarouselView
//
//  Created by SuperDanny on 2017/7/24.
//  Copyright © 2017年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCarouselViewRenderDelegate.h"

@interface CollectionViewCell : UICollectionViewCell <DDCarouselViewRenderDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *showImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@end
