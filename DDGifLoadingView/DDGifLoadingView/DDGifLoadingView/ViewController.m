//
//  ViewController.m
//  DDGifLoadingView
//
//  Created by SuperDanny on 15/11/14.
//  Copyright © 2015年 SuperDanny. All rights reserved.
//

#import "ViewController.h"
#import "DDGifLoadingView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *show;
@property (weak, nonatomic) IBOutlet UIButton *dismiss;
@property (weak, nonatomic) IBOutlet UIButton *showWithOverlay;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    for (int i = 0; i<26; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d", i]];
        [imageArray addObject:image];
    }

    [DDGifLoadingView setGifWithImages:imageArray];
    _show.exclusiveTouch = _dismiss.exclusiveTouch = _showWithOverlay.exclusiveTouch = YES;
}

- (IBAction)show:(id)sender {
    [DDGifLoadingView show];
}

- (IBAction)dismiss:(id)sender {
    [DDGifLoadingView dismiss];
}

- (IBAction)showWithOverlay:(id)sender {
    [DDGifLoadingView showWithOverlay];
    
    // dismiss after 2 seconds
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [DDGifLoadingView dismiss];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
