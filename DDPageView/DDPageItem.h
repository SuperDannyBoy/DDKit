//
//  DDPageItem.h
//  BannerView
//
//  Created by SuperDanny on 16/1/22.
//  Copyright © 2016年 SuperDanny. All rights reserved.
//

#import <Foundation/Foundation.h>

///描述
#define kItemInfoKey_Title @"title"
///URL
#define kItemInfoKey_URL   @"imageURL"

#define kItemInfoDic(title, url)   [NSDictionary dictionaryWithObjectsAndKeys:title,kItemInfoKey_Title, url,kItemInfoKey_URL, nil]

@interface DDPageItem : NSObject

@property (nonatomic, copy  ) NSString  *title;
@property (nonatomic, copy  ) NSString  *imageURL;
@property (nonatomic, assign) NSUInteger tag;

- (id)initWithTitle:(NSString *)title image:(NSString *)imageURL;
- (id)initWithDict:(NSDictionary *)dict tag:(NSUInteger)tag;

@end
