//
//  DDTabBarView.m
//  OShopping
//
//  Created by SuperDanny on 16/3/16.
//  Copyright © 2016年 MacauIT. All rights reserved.
//

#import "DDTabBarView.h"
#import "LKBadgeView.h"

#define kBadgeViewTag 19921020

@interface DDTabBarView ()

@property (strong, nonatomic) NSArray *imagesArr;
@property (strong, nonatomic) NSArray *titlesArr;
@property (strong, nonatomic) NSArray *itemArray;
@property (copy, nonatomic) void(^SelectBlock)(NSUInteger index);
@property (copy, nonatomic) void(^SelectBtnBlock)(NSUInteger index, UIButton *button);

@end

@implementation DDTabBarView

- (instancetype)initWithFrame:(CGRect)frame
                       Images:(NSArray *)imgs
                       Titles:(NSArray *)titles
               SelectBlockBtn:(void(^)(NSUInteger index, UIButton *button))block {
    if (self = [super initWithFrame:frame]) {
        self.imagesArr = [NSArray arrayWithArray:imgs];
        self.titlesArr = [NSArray arrayWithArray:titles];
        self.itemArray = [NSArray array];
        self.SelectBtnBlock = block;
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                       Images:(NSArray *)imgs
                       Titles:(NSArray *)titles
                  SelectBlock:(void(^)(NSUInteger index))block {
    if (self = [super initWithFrame:frame]) {
        self.imagesArr = [NSArray arrayWithArray:imgs];
        self.titlesArr = [NSArray arrayWithArray:titles];
        self.itemArray = [NSArray array];
        self.SelectBlock = block;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.layer.borderColor = [UIColor colorWithRed:0.863 green:0.867 blue:0.871 alpha:1.000].CGColor;
    self.borderWhich = ZJViewBorderTop;
    self.backgroundColor = [UIColor colorWithRed:0.976 green:0.980 blue:0.984 alpha:1.000];
    typeof(self) __weak weakSelf = self;
    CGFloat itemHeight = CGRectGetHeight(self.frame);
    if (_imagesArr.count) {
        CGFloat itemWidth  = CGRectGetWidth(self.frame)/_imagesArr.count;
        
        __block NSMutableArray *tempItemArray = [NSMutableArray array];
        [_imagesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(idx*itemWidth, 0, itemWidth, itemHeight)];
            [btn setTitleColor:[UIColorTools colorWithTheme:UIColorThemeGray1] forState:UIControlStateNormal];
            [tempItemArray addObject:btn];
            
            btn.exclusiveTouch = YES;
            
            UIImage *nor = [UIImage imageNamed:obj];
//            UIImage *sel = [UIImage imageNamed:[NSString stringWithFormat:@"%@选中", obj]];
            
            [btn setImage:nor forState:UIControlStateNormal];
//            [btn setImage:sel forState:UIControlStateSelected];
            
            if (weakSelf.titlesArr.count) {
                NSString *title = weakSelf.titlesArr[idx];
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [btn setTitle:title forState:UIControlStateNormal];
                
                CGFloat spacing = 6;
                // get the size of the elements here for readability
                CGSize imageSize = btn.imageView.frame.size;
                CGSize titleSize = btn.titleLabel.frame.size;
                // get the height they will take up as a unit
                CGFloat totalHeight = itemHeight;
                // raise the image and push it right to center it
                btn.imageEdgeInsets = UIEdgeInsetsMake(- titleSize.height, titleSize.width/2, 0.0, - titleSize.width/2);
                // lower the text and push it left to center it
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height - spacing), 0);
                
            }
            [btn bk_addEventHandler:^(id sender) {
                if (weakSelf.SelectBlock) {
                    weakSelf.SelectBlock(idx);
                }
                if (weakSelf.SelectBtnBlock) {
                    weakSelf.SelectBtnBlock(idx, sender);
                }
            } forControlEvents:UIControlEventTouchUpInside];
            [weakSelf addSubview:btn];
            
            //badgeNumber
            LKBadgeView *badgeView =
            [[LKBadgeView alloc] initWithFrame:CGRectMake(CGRectGetWidth(btn.frame)/2.0 - 5,
                                                          4.0, itemWidth/2.0,
                                                          20)];
            badgeView.widthMode = LKBadgeViewWidthModeSmall;
            badgeView.heightMode = LKBadgeViewHeightModeStandard;
            badgeView.tag = kBadgeViewTag + idx;
            badgeView.textColor  = [UIColor whiteColor];
            badgeView.badgeColor = [UIColor redColor];
//            badgeView.text = @"45";
            [btn addSubview:badgeView];
        }];
        
        _itemArray = [NSArray arrayWithArray:tempItemArray];
        
    } else if (_titlesArr.count) {
        CGFloat itemWidth  = CGRectGetWidth(self.frame)/_titlesArr.count;

        __block NSMutableArray *tempItemArray = [NSMutableArray array];

        [_titlesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(idx*itemWidth, 0, itemWidth, itemHeight)];
            [btn setTitleColor:[UIColorTools colorWithTheme:UIColorThemeGray1] forState:UIControlStateNormal];
            [tempItemArray addObject:btn];

            btn.exclusiveTouch = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitle:obj forState:UIControlStateNormal];
            
            if (weakSelf.imagesArr.count) {
                UIImage *img = weakSelf.imagesArr[idx];
                [btn setImage:img forState:UIControlStateNormal];
                
                CGFloat spacing = 6;
                // get the size of the elements here for readability
                CGSize imageSize = btn.imageView.frame.size;
                CGSize titleSize = btn.titleLabel.frame.size;
                // get the height they will take up as a unit
                CGFloat totalHeight = itemHeight;
                // raise the image and push it right to center it
                btn.imageEdgeInsets = UIEdgeInsetsMake(- titleSize.height, titleSize.width/2, 0, - titleSize.width/2);
                // lower the text and push it left to center it
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height - spacing), 0);
            }
            [btn bk_addEventHandler:^(id sender) {
                if (weakSelf.SelectBlock) {
                    weakSelf.SelectBlock(idx);
                }
            } forControlEvents:UIControlEventTouchUpInside];
            [weakSelf addSubview:btn];
            
            //badgeNumber
            LKBadgeView *badgeView =
            [[LKBadgeView alloc] initWithFrame:CGRectMake(CGRectGetWidth(btn.frame)/2.0 - 5,
                                                          4.0, itemWidth/2.0,
                                                          20)];
            badgeView.widthMode = LKBadgeViewWidthModeSmall;
            badgeView.heightMode = LKBadgeViewHeightModeStandard;
            badgeView.tag = kBadgeViewTag + idx;
            badgeView.textColor  = [UIColor whiteColor];
            badgeView.badgeColor = [UIColor redColor];
//            badgeView.text = @"45";
            [btn addSubview:badgeView];
        }];
        
        _itemArray = [NSArray arrayWithArray:tempItemArray];

    }
}

#pragma mark 设置最新数量
- (void)setBadgeValue:(NSString *)count index:(NSUInteger)index Type:(DDBadgeType)type {
    
    LKBadgeView *item = [self viewWithTag:kBadgeViewTag+index];
    
    switch (type) {
        case DDBadgeTypeDefault: {
            if ([count integerValue] != 0) {
                item.text = count;
            } else {
                item.text = @"";
            }
            break;
        }
        case DDBadgeTypeAdd: {
            NSString *badgeValue = [NSString stringWithFormat:@"%d", (int)([item.text integerValue]+[count integerValue])];
            item.text = badgeValue;
            break;
        }
        case DDBadgeTypeSubtract: {
            NSString *badgeValue = [NSString stringWithFormat:@"%d", (int)([item.text integerValue]-[count integerValue])];
            item.text = badgeValue;
            break;
        }
    }
}

@end
