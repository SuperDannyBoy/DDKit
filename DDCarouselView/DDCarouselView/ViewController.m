//
//  ViewController.m
//  DDCarouselView
//
//  Created by SuperDanny on 2017/7/24.
//  Copyright © 2017年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "ViewController.h"
#import "DDCarouselView.h"
#import "AdModel.h"

@interface ViewController () <DDCarouselViewDelegate> {
    DDCarouselView *_adView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self showAdVertically];//垂直显示
    [self showAdHorizontally];//水平显示
    
    
    CGFloat btnWidth = 100;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat margin_x = (screenWidth-btnWidth)/2;
    UIButton *btn = [[UIButton alloc]initWithFrame:(CGRect){margin_x-btnWidth-20,screenHeight-110,btnWidth,55}];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"play" forState:UIControlStateNormal];
    btn.alpha = 0.8;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn1 = [[UIButton alloc]initWithFrame:(CGRect){margin_x,screenHeight-110,btnWidth,55}];
    btn1.backgroundColor = [UIColor blueColor];
    [btn1 setTitle:@"pause" forState:UIControlStateNormal];
    btn1.alpha = 0.8;
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn2 = [[UIButton alloc]initWithFrame:(CGRect){margin_x+btnWidth+20,screenHeight-110,btnWidth,55}];
    btn2.backgroundColor = [UIColor greenColor];
    [btn2 setTitle:@"refresh" forState:UIControlStateNormal];
    btn2.alpha = 0.8;
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
    btn.layer.masksToBounds =YES;
    btn1.layer.masksToBounds = YES;
    btn2.layer.masksToBounds = YES;
    
    btn.layer.cornerRadius = 10;
    btn1.layer.cornerRadius = 10;
    btn2.layer.cornerRadius = 10;
    
}
#pragma mark - 垂直模式
/**
 *  @brief 垂直显示
 */
- (void)showAdVertically {
    
    NSArray *testArray = @[@"会员卡1.jpg",@"会员卡2.jpg",@"会员卡3.jpg"];
    //模拟服务器获取到的数据
    NSMutableArray *arrayFromService  = [NSMutableArray array];
    for (NSString *text in testArray) {
        AdModel *hero = [AdModel new];
        hero.imageName = text;
        hero.introduction = text;
        [arrayFromService addObject:hero];
    }
    
    DDCarouselView *adView = [[DDCarouselView alloc] initWithBuilder:^(DDCarouselViewBuilder *builder) {
        //必须参数
        builder.adArray = arrayFromService;

        builder.viewFrame = (CGRect){0,0,self.view.bounds.size.width,self.view.bounds.size.height/1.5f};
        builder.adItemSize = (CGSize){self.view.bounds.size.width/2.5f,self.view.bounds.size.width/4.f};
        builder.secondaryItemMinAlpha = 0.6;//非必要参数，设置非主要广告的alpa值
        builder.autoScrollDirection = DDCarouselViewScrollDirectionTop;//设置垂直向下滚动
        builder.itemCellNibName = @"CollectionViewCell";
        
        //非必要参数
//        builder.allowedInfinite = NO;  //非必要参数 ：设置不无限循环轮播,默认为Yes
//        builder.minimumLineSpacing = 40; //非必要参数: 如需要可填写，默认会自动计算
//        builder.scrollEnabled = NO;//非必要参数
        builder.threeDimensionalScale = 1.45;//非必要参数: 若需要使用threeD效果，则需要填写放大或缩小倍数
//        builder.allowedInfinite = NO;//非必要参数 : 如设置为NO，则按所需显示，不会无限轮播,也不具备轮播功能,默认为yes
        
    }];
    adView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.2];
    adView.delegate = self;
    _adView = adView;
    [self.view addSubview:adView];
}

#pragma mark - 水平模式
/**
 *  @brief 水平显示
 */
- (void)showAdHorizontally {
    NSArray *testArray = @[@"会员卡1.jpg",@"会员卡2.jpg",@"会员卡3.jpg"];
    //模拟服务器获取到的数据
    NSMutableArray *arrayFromService  = [NSMutableArray array];
    for (NSString *text in testArray) {
        AdModel *hero = [AdModel new];
        hero.imageName = text;
        hero.introduction = text;
        [arrayFromService addObject:hero];
    }
    
    DDCarouselView *adView = [[DDCarouselView alloc] initWithBuilder:^(DDCarouselViewBuilder *builder) {
        builder.adArray = arrayFromService;
        builder.viewFrame = (CGRect){0,100,self.view.bounds.size.width,self.view.bounds.size.width/2.f};
        //轮播图宽高比为：1.5
        builder.adItemSize = (CGSize){self.view.bounds.size.width/3.5f,self.view.bounds.size.width/5.25f};
        builder.minimumLineSpacing = 20;
        builder.secondaryItemMinAlpha = 0.6;
        builder.threeDimensionalScale = 1.3;
        builder.itemCellNibName = @"CollectionViewCell";
    }];
    adView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.2];
    adView.delegate = self;
    _adView = adView;
    [self.view addSubview:adView];
    
}
#pragma mark - delegate
- (void)dd_didClickAd:(id)adModel {
    NSLog(@"dd_didClickAd-->%@",adModel);
    if ([adModel isKindOfClass:[AdModel class]]) {
        NSLog(@"%@",((AdModel*)adModel).introduction);
    }
}

- (void)dd_scrollToIndex:(NSInteger)index {
    NSLog(@"dd_scrollToIndex-->%ld",index);
}

#pragma mark -operation
- (void)play {
    [_adView play];
}

- (void)pause {
    [_adView pause];
}

- (void)refresh {
    NSArray *testArray = @[@"会员卡2.jpg",@"会员卡2.jpg",@"会员卡2.jpg"];
    //模拟服务器获取到的数据
    NSMutableArray *arrayFromService  = [NSMutableArray array];
    for (NSString *text in testArray) {
        AdModel *hero = [AdModel new];
        hero.imageName = text;
        hero.introduction = text;
        [arrayFromService addObject:hero];
    }
    [_adView reloadWithDataArray:arrayFromService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
