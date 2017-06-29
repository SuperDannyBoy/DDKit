//
//  DDPageView.m
//  BannerView
//
//  Created by SuperDanny on 16/1/22.
//  Copyright © 2016年 SuperDanny. All rights reserved.
//

#import "DDPageView.h"
#import <objc/runtime.h>

#define ITEM_WIDTH [[UIScreen mainScreen] bounds].size.width
#define kNoneImageViewTag       20000

@interface DDPageView () <UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (nonatomic, assign) BOOL           isAutoPlay;
@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, strong) UIPageControl  *pageControl;
@property (nonatomic, strong) NSTimer        *timer;
@property (nonatomic, assign) NSTimeInterval scrollTime;
@property (nonatomic, copy  ) NSString       *placeholderImage;
@property (nonatomic, assign) BOOL           isShowTitle;
@property (nonatomic, copy  ) DDNoneDataCallBack    noneDataCallBack;
@property (nonatomic, assign) UIViewContentMode imageViewContentMode;

@end

static NSString *DDPageItemsKey = @"DDPageItemsKey";

@implementation DDPageView
- (void)setViewFrame:(CGRect)frame delegate:(id<DDPageViewDelegate>)delegate timeInterval:(NSTimeInterval)time contentMode:(UIViewContentMode)contentMode placeholderImage:(NSString *)placeholderImage focusImageItems:(DDPageItem *)firstItem, ... {
    NSMutableArray *imageItems = [NSMutableArray array];
    DDPageItem *eachItem;
    va_list argumentList;
    if (firstItem) {
        [imageItems addObject: firstItem];
        va_start(argumentList, firstItem);
        while ((eachItem = va_arg(argumentList, DDPageItem *))) {
            [imageItems addObject: eachItem];
        }
        va_end(argumentList);
    }
    [self setViewFrame:frame delegate:delegate timeInterval:time contentMode:contentMode placeholderImage:placeholderImage imageArray:imageItems isAuto:time <= 0 ? NO : YES];
}

- (void)setViewFrame:(CGRect)frame delegate:(id<DDPageViewDelegate>)delegate timeInterval:(NSTimeInterval)time contentMode:(UIViewContentMode)contentMode placeholderImage:(NSString *)placeholderImage imageArray:(NSArray *)array {
    [self setViewFrame:frame delegate:delegate timeInterval:time contentMode:contentMode placeholderImage:placeholderImage imageArray:array isAuto:time <= 0 ? NO : YES];
}

- (void)setViewFrame:(CGRect)frame delegate:(id<DDPageViewDelegate>)delegate timeInterval:(NSTimeInterval)time contentMode:(UIViewContentMode)contentMode placeholderImage:(NSString *)placeholderImage imageArray:(NSArray *)array showTitle:(BOOL)isShow {
    self.isShowTitle = isShow;
    [self setViewFrame:frame delegate:delegate timeInterval:time contentMode:contentMode placeholderImage:placeholderImage imageArray:array isAuto:time <= 0 ? NO : YES];
}

- (void)setViewFrame:(CGRect)frame delegate:(id<DDPageViewDelegate>)delegate timeInterval:(NSTimeInterval)time contentMode:(UIViewContentMode)contentMode placeholderImage:(NSString *)placeholderImage imageArray:(NSArray *)array isAuto:(BOOL)isAuto {
    self.frame = frame;
    _isAutoPlay = isAuto;
    _placeholderImage = placeholderImage;
    _scrollTime = time;
    _imageViewContentMode = contentMode;
    [self setImageItems:array];
    _delegate = delegate;
}

- (void)dealloc {
    objc_setAssociatedObject(self, (__bridge const void *)DDPageItemsKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    _scrollView.delegate = nil;
}

#pragma mark - Public Method
- (void)reloadData:(NSArray *)array {
    [self setImageItems:array];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)setPageBackgroundColor:(UIColor *)pageBackgroundColor {
    if (pageBackgroundColor) {
        _scrollView.backgroundColor = pageBackgroundColor;
    }
}

- (void)setDDNoneDataCallback:(DDNoneDataCallBack)block {
    self.noneDataCallBack = block;
}
#pragma mark - private methods
- (void)setImageItems:(NSArray *)array {
    if (array.count == 0 || !array) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:kNoneImageViewTag];
        if (imageView) {
            [imageView removeFromSuperview];
        }
        [self setupNoneView];
        return;
    }
    NSUInteger length = [array count];
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    //添加最后一张图 用于循环
    if (length > 1) {
        NSDictionary *dict = array[length-1];
        DDPageItem *item = [[DDPageItem alloc] initWithDict:dict tag:-1];
        [itemArray addObject:item];
    }
    for (int i = 0; i < length; i++) {
        NSDictionary *dict = array[i];
        DDPageItem *item = [[DDPageItem alloc] initWithDict:dict tag:i];
        [itemArray addObject:item];
    }
    //添加第一张图 用于循环
    if (length >1) {
        NSDictionary *dict = array[0];
        DDPageItem *item = [[DDPageItem alloc] initWithDict:dict tag:length];
        [itemArray addObject:item];
    }
    
    NSMutableArray *imageItems = [NSMutableArray arrayWithArray:itemArray];
    objc_setAssociatedObject(self, (__bridge const void *)DDPageItemsKey, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (_timer) {
        [self stopTimer];
    }
    //当轮播图数量大于1时才启动定时器播放
    if (array.count > 1) {
        [self createTimer];
    }
    
    [self setupViews];
}

- (void)createTimer {
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollTime]
                                      interval:_scrollTime
                                        target:self
                                      selector:@selector(switchFocusImageItems)
                                      userInfo:nil
                                       repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)setupNoneView {
    UIImageView *noneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.placeholderImage] highlightedImage:[UIImage imageNamed:self.placeholderImage]];
    noneImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    noneImageView.userInteractionEnabled = YES;
    noneImageView.contentMode = UIViewContentModeScaleToFill;
    noneImageView.clipsToBounds = YES;
    noneImageView.tag = kNoneImageViewTag;
    __weak typeof(self) weakSelf = self;
    [noneImageView bk_whenTapped:^{
        if (weakSelf.noneDataCallBack) {
            weakSelf.noneDataCallBack();
        }
    }];
    [self addSubview:noneImageView];
}
- (void)setupViews {
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)DDPageItemsKey);
    
    if (!_scrollView) {
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _scrollView = [[UIScrollView alloc] initWithFrame:rect];
        [self addSubview:_scrollView];
    }
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    _scrollView.scrollsToTop                   = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled                  = YES;
    _scrollView.delegate                       = self;
    _scrollView.backgroundColor                = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame) * imageItems.count, CGRectGetHeight(_scrollView.frame));
    /*
     _scrollView.layer.cornerRadius = 10;
     _scrollView.layer.borderWidth = 1 ;
     _scrollView.layer.borderColor = [[UIColor lightGrayColor ] CGColor];
     */
    
    float space = 0;
    CGSize size = CGSizeMake(ITEM_WIDTH, 0);
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 15, ITEM_WIDTH, 5)];
        
        // BUG #3657 澳门咨询---澳门时报-----下拉刷新，导航新闻往下偏移。
        if (self.isShowTitle) {
            CGRect rect = _pageControl.frame;
            rect.origin.y = rect.origin.y + 0.7;
            _pageControl.frame = rect;
        }
        
        [self addSubview:_pageControl];
    }
    _pageControl.userInteractionEnabled = NO;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.numberOfPages = imageItems.count > 1 ? imageItems.count-2 : imageItems.count;
    _pageControl.currentPage = 0;
    _pageControl.hidesForSinglePage = YES;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    
    for (int i = 0; i < imageItems.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.frame.size.width+space, space, _scrollView.frame.size.width-space*2, _scrollView.frame.size.height-2*space-size.height)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        DDPageItem *item = imageItems[i];
        NSURL *url = [NSURL URLWithString:item.imageURL];
        [imageView sd_setImageWithURL:url
                     placeholderImage:[UIImage imageNamed:_placeholderImage]
                              options:SDWebImageRefreshCached | SDWebImageProgressiveDownload
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                if (!error) {
//                                    imageView.contentMode = UIViewContentModeScaleAspectFit;
//                                }
                              }];
        [_scrollView addSubview:imageView];
        
        if (self.isShowTitle) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(imageView.frame) - 40.0,
                                                                    CGRectGetWidth(imageView.frame) - 0.0, 40.0)];
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
            [imageView addSubview:view];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 1.0,
                                                                            CGRectGetWidth(imageView.frame) - 10.0,
                                                                            25.0)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = item.title;
            titleLabel.textColor = [UIColor whiteColor];
            [view addSubview:titleLabel];
        }
    }
    if (imageItems.count > 1) {
        [_scrollView setContentOffset:CGPointMake(ITEM_WIDTH, 0) animated:NO] ;
        if (_isAutoPlay) {
            if (_timer) {
                [self stopTimer];
            }
            [self createTimer];
        }
    }
}

- (void)switchFocusImageItems {
    CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
    //    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)DDPageItemsKey);
    targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
    [self moveToTargetPosition:targetX];
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)DDPageItemsKey);
    int page = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    if (page > -1 && page < imageItems.count) {
        DDPageItem *item = imageItems[page];
        if ([self.delegate respondsToSelector:@selector(foucusView:didSelectItem:index:)]) {
            [self.delegate foucusView:self didSelectItem:item index:item.tag];
        }
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX {
    BOOL animated = YES;
    //    NSLog(@"moveToTargetPosition : %f" , targetX);
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //开始拖动scrollview的时候，停止计时器控制的跳转
    [self stopTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float targetX = scrollView.contentOffset.x;
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)DDPageItemsKey);
    if (imageItems.count >= 3) {
        if (targetX >= ITEM_WIDTH * (imageItems.count-1)) {
            targetX = ITEM_WIDTH;
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
        else if(targetX <= 0) {
            targetX = ITEM_WIDTH *(imageItems.count-2);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    NSInteger page = (_scrollView.contentOffset.x+ITEM_WIDTH/2.0) / ITEM_WIDTH;
    //    NSLog(@"%f %d",_scrollView.contentOffset.x,page);
    if (imageItems.count > 1) {
        page--;
        if (page >= _pageControl.numberOfPages) {
            page = 0;
        } else if (page < 0) {
            page = _pageControl.numberOfPages-1;
        }
    }
    if (page != _pageControl.currentPage) {
        if ([self.delegate respondsToSelector:@selector(foucusView:currentItem:)]) {
            [self.delegate foucusView:self currentItem:page];
        }
    }
    _pageControl.currentPage = page;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
        [self moveToTargetPosition:targetX];
    }
    //拖动完毕的时候，重新开始计时器控制跳转
    if (!_timer && _isAutoPlay) {
        [self createTimer];
    }
}

- (void)scrollToIndex:(NSInteger)aIndex {
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)DDPageItemsKey);
    if (imageItems.count > 1) {
        if (aIndex >= (imageItems.count-2)) {
            aIndex = imageItems.count-3;
        }
        [self moveToTargetPosition:ITEM_WIDTH*(aIndex+1)];
    } else {
        [self moveToTargetPosition:0];
    }
    [self scrollViewDidScroll:_scrollView];
}
@end