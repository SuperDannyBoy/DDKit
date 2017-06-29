//
//  PopoverView.h
//

#import <UIKit/UIKit.h>

typedef void(^PopoverBlock)(NSInteger index);

@interface PopoverView : UIView

// 菜单列表集合
@property (nonatomic, copy) NSArray *menuTitles;

/*!
 *
 *  @brief 显示弹窗
 *
 *  @param aView    箭头指向的控件
 *  @param selected 选择完成回调
 */
- (void)showFromView:(UIView *)aView selected:(PopoverBlock)selected;

@end


@interface PopoverArrow : UIView

@end