//
//  DDAlertController.h
//
//  Created by SuperDanny on 2017/1/5.
//  Copyright © 2017年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDAlertAction : UIAlertAction

@property (nonatomic,strong) UIColor *textColor; /**< 按钮title字体颜色 */

@end

@interface DDAlertController : UIAlertController

@property (nonatomic,strong) UIColor *tintColor; /**< 统一按钮样式 不写系统默认的蓝色 */
@property (nonatomic,strong) UIColor *titleColor; /**< 标题的颜色 */
@property (nonatomic,strong) UIColor *messageColor; /**< 信息的颜色 */

@end
