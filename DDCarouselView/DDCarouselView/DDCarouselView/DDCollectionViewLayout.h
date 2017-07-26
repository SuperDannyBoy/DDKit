//
//  DDCollectionViewLayout.h
//  DDCarouselView
//
//  Created by SuperDanny on 2017/7/24.
//  Copyright © 2017年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCollectionViewLayout : UICollectionViewFlowLayout

///非当前广告的alpha值
@property (nonatomic, assign) CGFloat secondaryItemMinAlpha;

///3D缩放值，若为0，则为2D广告
@property (nonatomic, assign) CGFloat threeDimensionalScale;

@end
