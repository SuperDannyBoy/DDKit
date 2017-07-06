//
//  ViewController.m
//  DDAddressBook
//
//  Created by SuperDanny on 2017/7/6.
//  Copyright © 2017年 SuperDanny. All rights reserved.
//

#import "ViewController.h"
#import "AddressBookViewController.h"

#import "CheckTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)openAddressBook:(id)sender {
    if ([CheckTools isPermissionsWithType:AddressBookPermissions]) {
        AddressBookViewController *vc = [[AddressBookViewController alloc] init];
        vc.block = ^(AddressBookEntity *entity) {
            NSLog(@"%@", entity.phoneStr);
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
