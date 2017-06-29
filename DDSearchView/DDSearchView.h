//
//  DDSearchView.h
//  OShopping
//
//  Created by SuperDanny on 16/3/22.
//  Copyright © 2016年 MacauIT. All rights reserved.
//

#import <UIKit/UIKit.h>

///搜索视图类型
typedef NS_ENUM(NSUInteger, ViewType) {
    ///包含商品、店铺
    ViewTypeBoth,
    ///只搜商品
    ViewTypeAlone,
};

@interface DDSearchView : UIView

- (instancetype)initWithViewType:(ViewType)type storeId:(NSString *)store_id;

@end
