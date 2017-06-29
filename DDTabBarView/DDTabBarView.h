//
//  DDTabBarView.h
//  OShopping
//
//  Created by SuperDanny on 16/3/16.
//  Copyright © 2016年 MacauIT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDBadgeType) {
    //替换
    DDBadgeTypeDefault = 0,
    //增加
    DDBadgeTypeAdd,
    //减少
    DDBadgeTypeSubtract
};

@interface DDTabBarView : UIView

///初始化后返回所有item
@property (nonatomic, strong, readonly) NSArray *itemArray;

- (instancetype)initWithFrame:(CGRect)frame
                       Images:(NSArray *)imgs
                       Titles:(NSArray *)titles
               SelectBlockBtn:(void(^)(NSUInteger index, UIButton *button))block;

- (instancetype)initWithFrame:(CGRect)frame
                       Images:(NSArray *)imgs
                       Titles:(NSArray *)titles
                  SelectBlock:(void(^)(NSUInteger index))block;
///设置最新数量
- (void)setBadgeValue:(NSString *)count index:(NSUInteger)index Type:(DDBadgeType)type;

@end
