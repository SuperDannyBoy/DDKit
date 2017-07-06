//
//  UIImage+TestImage.m
//  TreatHelper
//
//  Created by 李必武 on 13-1-24.
//  Copyright (c) 2013年 李必武. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage(Addition)

/*翻转*/
- (UIImage *)flip:(BOOL)isHorizontal {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    if (&UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    } else {
//        UIGraphicsBeginImageContext(rect.size);
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClipToRect(ctx, rect);
    if (isHorizontal) {
        CGContextRotateCTM(ctx, M_PI);
        CGContextTranslateCTM(ctx, -rect.size.width, -rect.size.height);
    }
    CGContextDrawImage(ctx, rect, self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*垂直翻转*/
- (UIImage *)flipVertical {
    return [self flip:NO];
}
/*水平翻转*/
- (UIImage *)flipHorizontal {
    return [self flip:YES];
}
//压缩图片
- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height {
    CGSize size = CGSizeMake(width, height);
    if (&UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    } else {
//        UIGraphicsBeginImageContext(size);
    }
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/*返回一张拉伸不变形的图片 从中间拉伸*/
- (UIImage *)resizableImage
{
    CGFloat edgeW = self.size.width * 0.5;
    CGFloat edgeH = self.size.height * 0.5;
    return [self stretchableImageWithLeftCapWidth:edgeW topCapHeight:edgeH];
}
//crop
- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect) ;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

//调整方向
- (UIImage *)fixOrientation{
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (UIImage *)scaledImageV2WithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight{
    CGRect rect = CGRectIntegral(CGRectMake(0, 0, aWidth,aHeight));
	UIGraphicsBeginImageContext(rect.size);
	[self drawInRect:rect];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

- (UIImage *)scaledImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
	aWidth = aWidth > self.size.width ? self.size.width : aWidth;
	aHeight = aHeight > self.size.height ? self.size.height : aHeight;
	
	CGRect rect = CGRectIntegral(CGRectMake(0, 0, aWidth,aHeight));
	UIGraphicsBeginImageContext(rect.size);
	[self drawInRect:rect];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

- (UIImage *)scaledHeadImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    CGSize endSize = CGSizeMake(aWidth, aHeight);
    CGRect backRect = CGRectMake(0, 0, aWidth, aHeight);
    float imagex =0;
    float imagey =0;
    
    BOOL needBack = NO;
    if (self.size.width > self.size.height) {
        aWidth = aWidth > self.size.width ? self.size.width : aWidth;
        imagex =0;
        float ff = self.size.width /aWidth;
        aHeight = self.size.height/ff;
        imagey = (aWidth-aHeight)/2;
        needBack =YES;
        backRect = CGRectMake(0, 0, aWidth, aWidth);
        endSize = CGSizeMake(aWidth, aWidth);
    }
    else if(self.size.width < self.size.height)
    {
        aHeight = aHeight > self.size.height ? self.size.height : aHeight;
        imagey =0;
        float ff = self.size.height /aHeight;
        aWidth = self.size.width/ff;
        imagex = (aHeight-aWidth)/2;
        needBack =YES;
        backRect = CGRectMake(0, 0, aHeight, aHeight);
        endSize = CGSizeMake(aHeight, aHeight);
    }
    else
    {
        aWidth = aWidth > self.size.width ? self.size.width : aWidth;
        aHeight = aHeight > self.size.height ? self.size.height : aHeight;
	}
	CGRect rect = CGRectMake(imagex, imagey, aWidth,aHeight);
	UIGraphicsBeginImageContext(endSize);  //rect.size);
    
    if (needBack) {
        // get a reference to that context we created
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        UIColor *color = [UIColor blackColor];
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextAddRect(context, backRect);
        CGContextDrawPath(context,kCGPathFill);
    }
	[self drawInRect:rect];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}
+ (UIImage *)lineImage {
    UIImage *image = [UIImage imageNamed:@"line"];
    return image;
}

+ (UIImage *)imaginarylineImage {
    UIImage *image = [UIImage imageNamed:@"imaginaryline"];
    return image;
}

// 生成一张指定颜色的图片
+(UIImage*)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

+ (UIImage *)cellBackImage {
    UIImage *image = [UIImage imageNamed:@"cellBackgroundColor"];
    image =[image resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0) resizingMode:UIImageResizingModeStretch];
    return image;
}

+ (UIImage *)cellBackImageGray {
    UIImage *image = [UIImage imageNamed:@"cellBackgroundColorGray"];
    image =[image resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0) resizingMode:UIImageResizingModeStretch];
    return image;
}

+ (UIImage *)cellBackImageTop {
    UIImage *image = [UIImage imageNamed:@"cellBackgroundColor_top"];
    image =[image resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0) resizingMode:UIImageResizingModeStretch];
    return image;
}

+ (UIImage *)cellBackImageMiddle {
    UIImage *image = [UIImage imageNamed:@"cellBackgroundColor_mid"];
    image =[image resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0) resizingMode:UIImageResizingModeStretch];
    return image;
}

+ (UIImage *)cellBackImageButtom {
    UIImage *image = [UIImage imageNamed:@"cellBackgroundColor_buttom"];
    image =[image resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0) resizingMode:UIImageResizingModeStretch];
    return image;
}
///正方形
+ (UIImage *)placeholderImage_square {
    UIImage * image = [UIImage imageNamed:@"placeholderImage200_200"];
    return image;
}
///长方形
+ (UIImage *)placeholderImage_rectangle {
    UIImage * image = [UIImage imageNamed:@"placeholderImage320_150"];
    return image;
}
///首页大广告
+ (UIImage *)placeholderImage_bigAdv {
    UIImage * image = [UIImage imageNamed:@"placeholderImage_adv"];
    return image;
}

#pragma mark - 加载资源图片(xcassets资源无法加载)
+ (UIImage *)imagePNGNamed:(NSString *)name {
    return [self image_Named:[name stringByAppendingString:@".png"]];
}

/*!
 *  @author SuperDanny
 *
 *  加载资源图片(xcassets资源无法加载)
 *
 *  @param name  资源文件名(需带后缀)
 *
 *  @return UIImage
 */
+ (UIImage *)image_Named:(NSString *)name {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return nil;
    
    NSString *res = name.stringByDeletingPathExtension;
    NSString *ext = name.pathExtension;
    NSString *path = nil;
    CGFloat scale = 1;
    
    // If no extension, guess by system supported (same as UIImage).
    NSArray *exts = ext.length > 0 ? @[ext] : @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp", @"apng"];
    NSArray *scales = _NSBundlePreferredScales();
    for (int s = 0; s < scales.count; s++) {
        scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = _NSStringByAppendingNameScale(res, scale);
        for (NSString *e in exts) {
            path = [[NSBundle mainBundle] pathForResource:scaledName ofType:e];
            if (path) break;
        }
        if (path) break;
    }
    if (path.length == 0) return nil;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data.length == 0) return nil;
    
    return [[self alloc] initWithData:data scale:scale];
}

/**
 An array of NSNumber objects, shows the best order for path scale search.
 e.g. iPhone3GS:@[@1,@2,@3] iPhone5:@[@2,@3,@1]  iPhone6 Plus:@[@3,@2,@1]
 */
static NSArray *_NSBundlePreferredScales() {
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1,@2,@3];
        } else if (screenScale <= 2) {
            scales = @[@2,@3,@1];
        } else {
            scales = @[@3,@2,@1];
        }
    });
    return scales;
}

/**
 Add scale modifier to the file name (without path extension),
 From @"name" to @"name@2x".
 
 e.g.
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon.top" </td><td>"icon.top@2x" </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale Resource scale.
 @return String by add scale modifier, or just return if it's not end with file name.
 */
static NSString *_NSStringByAppendingNameScale(NSString *string, CGFloat scale) {
    if (!string) return nil;
    if (fabs(scale - 1) <= __FLT_EPSILON__ || string.length == 0 || [string hasSuffix:@"/"]) return string.copy;
    return [string stringByAppendingFormat:@"@%@x", @(scale)];
}

@end
