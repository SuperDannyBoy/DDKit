//
//  UIImage+TestImage.h
//  DDCategory
//
//  Created by SuperDanny on 15/8/6.
//  Copyright © 2015年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(Addition)

/*垂直翻转*/
- (UIImage *)flipVertical;

/*水平翻转*/
- (UIImage *)flipHorizontal;

/*改变size*/   //压缩图片
- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;
/*返回一张拉伸不变形的图片 从中间拉伸*/
- (UIImage *)resizableImage;
//crop
- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

//确认image的真实orientation
- (UIImage *)fixOrientation;

- (UIImage *)scaledImageV2WithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;
- (UIImage *)scaledImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;
- (UIImage *)scaledHeadImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;

// 生成一张指定颜色的图片
+(UIImage*)imageWithColor:(UIColor*)color;

+ (UIImage *)cellBackImage;
+ (UIImage *)cellBackImageGray;
+ (UIImage *)cellBackImageTop;
+ (UIImage *)cellBackImageMiddle;
+ (UIImage *)cellBackImageButtom;
///正方形
+ (UIImage *)placeholderImage_square;
///长方形
+ (UIImage *)placeholderImage_rectangle;
///首页大广告
+ (UIImage *)placeholderImage_bigAdv;
+ (UIImage *)lineImage;
+ (UIImage *)imaginarylineImage;


/*!
 *  @author SuperDanny
 *
 *  加载资源图片(xcassets资源无法加载)
 *
 *  @param name  资源文件名(需带后缀)
 *
 *  @return UIImage
 */
+ (UIImage *)image_Named:(NSString *)name;
+ (UIImage *)imagePNGNamed:(NSString *)name;

@end
