//
//  AddressBookResultsTableViewController.h
//  DDAddressBook
//
//  Created by SuperDanny on 2017/6/15.
//  Copyright © 2017年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//
//  搜索结果

#import <UIKit/UIKit.h>

@class AddressBookEntity;

@interface AddressBookResultsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray<AddressBookEntity *> *resultsArr;

@end
