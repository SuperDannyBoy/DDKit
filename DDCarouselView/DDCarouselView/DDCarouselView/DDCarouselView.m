//
//  DDCarouselView.m
//  DDCarouselView
//
//  Created by SuperDanny on 2017/7/24.
//  Copyright © 2017年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "DDCarouselView.h"
#import "DDCollectionViewLayout.h"

///默认的自动轮播的时间间隔
#define kDDBuilderDefaultAutoScrollCycle 3.0
///2D时自动计算linespacing的倍数
#define kDDBuilderAutoSetLineSpacingRatio 0.15
///不使用3D缩放  >0起效
#define kDDBuilder_NO_3D -1
///最小的行间距 如果不足够大，会出现两行的情况
#define kDDBuilderDefaultMinimumInteritemSpacing 10000

#define kDDAdCellIdentifier @"kDDAdCellIdentifier"
#define kDDError(_DESC_)  NSCAssert(0,_DESC_)
#define kDDPrepareItemTime 2

@interface DDCarouselView() {
    DDCarouselViewBuilder *_builder;
    /*
     * 因为当用户滑动的时候，轮播不应该继续，所以会被停掉
     * 但是当滑动结束，会根据是否开启了轮播而重新开启
     */
    BOOL _isPlaying; //真实是否开启了播放的状态
    BOOL _expctedToPlay;//用户启动的play
}

///计时器
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DDCarouselViewBuilder

@end

@interface DDCarouselView() <UICollectionViewDelegate,UICollectionViewDataSource>

///collection
@property (nonatomic, strong) UICollectionView *collectionView;

///data
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DDCarouselView

- (instancetype)initWithBuilder:(void (^) (DDCarouselViewBuilder *builder))builderBlock {
    if (self = [super init]) {
        DDCarouselViewBuilder *builder = [DDCarouselViewBuilder new];
        builder.allowedInfinite = YES;
        builder.scrollEnabled = YES;
        builder.infiniteCycle = kDDBuilderDefaultAutoScrollCycle;
        builder.threeDimensionalScale  = kDDBuilder_NO_3D;
        builder.minimumInteritemSpacing = kDDBuilderDefaultMinimumInteritemSpacing;
        builder.minimumLineSpacing = kDDBuilderLineSpacingAuto;
        if (builderBlock) {
            builderBlock(builder);
        }
        [self _auto_set_builder:builder];
        [self setUpWithBuilder:builder];
    }
    return self;
}

- (void)_auto_set_builder:(DDCarouselViewBuilder *)builder {
    //自动填充lineSpacing
    if (builder.minimumLineSpacing==kDDBuilderLineSpacingAuto) {
        if (builder.threeDimensionalScale>1) {
            if (builder.autoScrollDirection>1) {//用户漏了填写间距，将自动填写
                builder.minimumLineSpacing = (builder.threeDimensionalScale-1)*builder.adItemSize.height/1;
            } else {
                builder.minimumLineSpacing = (builder.threeDimensionalScale-1)*builder.adItemSize.width/1;
            }
        } else if (builder.threeDimensionalScale<0) {
            if (builder.autoScrollDirection>1) {//用户漏了填写间距，将自动填写
                builder.minimumLineSpacing = kDDBuilderAutoSetLineSpacingRatio*builder.adItemSize.height/1;
            } else {
                builder.minimumLineSpacing = kDDBuilderAutoSetLineSpacingRatio*builder.adItemSize.width/1;
            }
        }
    }
}
/**
 *  @brief 初始化
 */
- (void)setUpWithBuilder:(DDCarouselViewBuilder *)builder {
    _builder = builder;
    self.frame = builder.viewFrame;
    NSArray *dataArray = @[];
    if (!builder.allowedInfinite) {
        if (builder.adArray) {
             self.dataArray = [NSMutableArray arrayWithArray:builder.adArray];
        }
    } else {//无限轮播
        if (builder.adArray && builder.adArray.count>0) {
            for (int i=0;i<2*kDDPrepareItemTime+1;i++) {
                dataArray = [dataArray arrayByAddingObjectsFromArray:builder.adArray];
            }
        }
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
    }
    DDCollectionViewLayout *layout = [DDCollectionViewLayout new];
    layout.scrollDirection = (_builder.autoScrollDirection>1)?UICollectionViewScrollDirectionVertical:UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = builder.adItemSize;
    layout.minimumLineSpacing = builder.minimumLineSpacing;
    layout.minimumInteritemSpacing = builder.minimumInteritemSpacing;
    layout.secondaryItemMinAlpha = builder.secondaryItemMinAlpha;
    layout.threeDimensionalScale = builder.threeDimensionalScale;
    if (_builder.autoScrollDirection>1) {
        CGFloat y_inset =(self.frame.size.height-layout.itemSize.height) / 2.f;
        layout.sectionInset = UIEdgeInsetsMake(y_inset,0,y_inset,0);
    } else {
        CGFloat x_inset =(self.frame.size.width-layout.itemSize.width) / 2.f;
        layout.sectionInset = UIEdgeInsetsMake(0, x_inset, 0, x_inset);
    }
    self.collectionView = [[UICollectionView alloc]initWithFrame:(CGRect){0,0,self.frame.size} collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.decelerationRate = 0;
    self.collectionView.scrollEnabled = builder.scrollEnabled;
    if (builder.itemCellNibName.length>0) {
        UINib *nib = [UINib nibWithNibName:builder.itemCellNibName bundle:nil];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:kDDAdCellIdentifier];
    } else if (builder.itemCellClassName.length>0 && NSClassFromString(builder.itemCellClassName)){
        [self.collectionView registerClass:NSClassFromString(builder.itemCellClassName) forCellWithReuseIdentifier:kDDAdCellIdentifier];
    } else {
        kDDError(@"builder必须参数缺失 : ------>必须在builder指定一个cell的类或者nib");
    }
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_builder.allowedInfinite) {
        CGPoint offet;
        if (_builder.autoScrollDirection<=1) {
           offet = (CGPoint){(_builder.adItemSize.width+_builder.minimumLineSpacing)*(_builder.adArray.count)*kDDPrepareItemTime,0};
        } else {
           offet = (CGPoint){0,(_builder.adItemSize.height+_builder.minimumLineSpacing)*(_builder.adArray.count)*kDDPrepareItemTime};
        }
        
        [self.collectionView setContentOffset:offet];
    }
}
/**
 *  @brief 计时器执行方法,增加偏移量
 */
- (void)_playNextAd {
    CGPoint pInUnderView = [self convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取中间的indexpath
    NSIndexPath *indexpath = [self.collectionView indexPathForItemAtPoint:pInUnderView];
    // 获取滑动目标的indexPath
    NSIndexPath *to_indexPath;
    if (_builder.autoScrollDirection==DDCarouselViewScrollDirectionRight || _builder.autoScrollDirection==DDCarouselViewScrollDirectionBotom){
        to_indexPath=[NSIndexPath indexPathForRow:indexpath.row+1 inSection:0];//向右或向下
    } else {
        to_indexPath=[NSIndexPath indexPathForRow:indexpath.row-1 inSection:0];//向左或向上
    }
    if (_builder.autoScrollDirection>1) {
        [self.collectionView scrollToItemAtIndexPath:to_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    } else {
        [self.collectionView scrollToItemAtIndexPath:to_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}
#pragma mark -collection delegate/datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataArray[indexPath.item];
    UICollectionViewCell<DDCarouselViewRenderDelegate> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDDAdCellIdentifier forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

// 点击item的时候
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CGPoint pInUnderView = [self convertPoint:collectionView.center toView:collectionView];
    
    // 获取中间的indexpath
    NSIndexPath *indexpathNew = [collectionView indexPathForItemAtPoint:pInUnderView];
    
    if (indexPath.row == indexpathNew.row) {
        //点击了中间的广告
        if (self.delegate &&[self.delegate respondsToSelector:@selector(dd_didClickAd:)]) {
            [self.delegate dd_didClickAd:self.dataArray[indexPath.row]];
        }
    } else {
        //点击了背后的广告，将会被移动上来
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self _secretlyChangeIndex];
    if (_expctedToPlay) {
        [self play];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self _secretlyChangeIndex];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_expctedToPlay) {
        [self _pauseOperation];
    }
}

- (void)_secretlyChangeIndex {
    CGPoint pInUnderView = [self convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取中间的indexpath
    NSIndexPath *indexpath = [self.collectionView indexPathForItemAtPoint:pInUnderView];
    NSInteger itemCount =_builder.adArray.count;
    if (indexpath.row<itemCount*kDDPrepareItemTime || indexpath.row>=itemCount*(kDDPrepareItemTime+1)) {
        NSIndexPath *to_indexPath =[NSIndexPath indexPathForRow:indexpath.row%itemCount+itemCount*kDDPrepareItemTime inSection:0];
        if (_builder.autoScrollDirection>1) {
            [self.collectionView scrollToItemAtIndexPath:to_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        } else {
            [self.collectionView scrollToItemAtIndexPath:to_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
    
    // 把collectionView本身的中心位子（固定的）,转换成collectionView整个内容上的point
    CGPoint pInView = [self.collectionView.superview convertPoint:self.collectionView.center toView:self.collectionView];
    
    // 通过坐标获取对应的indexpath
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
    NSInteger index = indexPathNow.row;
    if (self.delegate && [self.delegate respondsToSelector:@selector(dd_scrollToIndex:)]) {
        [self.delegate dd_scrollToIndex:index%_builder.adArray.count];
    }
}

#pragma mark -override
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    [self.collectionView setBackgroundColor:backgroundColor];
}


#pragma mark operate
- (void)play {
    if (_builder.allowedInfinite) {
        [self _pauseOperation];
        _expctedToPlay = YES;
        _isPlaying = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.timer){
                self.timer =[NSTimer scheduledTimerWithTimeInterval:_builder.infiniteCycle target:self selector:@selector(_playNextAd) userInfo:nil repeats:YES];
            }
        });
    } else {
        kDDError(@"builder没有允许无限轮播");
    }
    
}
- (void)pause {
    _expctedToPlay = NO;
    [self _pauseOperation];
}
- (void)_pauseOperation {
    _isPlaying = NO;
    if (_builder.allowedInfinite) {
        if (self.timer) {
             [self.timer invalidate];
        }
        self.timer = nil;
    }
}
- (void)reloadWithDataArray:(NSArray *)adArray {
    NSArray *dataArray = @[];
    if (!_builder.allowedInfinite) {
        if (adArray) {
            self.dataArray = [NSMutableArray arrayWithArray:adArray];
        }
    } else {//无限轮播
        if (adArray && adArray.count>0) {
            for (int i=0;i<2*kDDPrepareItemTime+1;i++) {
                dataArray = [dataArray arrayByAddingObjectsFromArray:adArray];
            }
        }
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
    }
    [self.collectionView reloadData];
}
@end
