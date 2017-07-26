//
//  DDCarouselViewRenderDelegate.h
//  DDCarouselView
//
//  Created by SuperDanny on 2017/7/24.
//  Copyright © 2017年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DDCarouselViewRenderDelegate <NSObject>

@required
/**
 *  @brief 通过实现此代理为view或者cell来设置
 */
- (void)setModel:(id)model;

@end
