//
//  AddressBookResultsTableViewController.m
//  DDAddressBook
//
//  Created by SuperDanny on 2017/6/15.
//  Copyright © 2017年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "AddressBookResultsTableViewController.h"
#import "AddressBookEntity.h"

NSString *const kCellIdentifier = @"cellID";

@interface AddressBookResultsTableViewController ()

@end

@implementation AddressBookResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    AddressBookEntity *entity = _resultsArr[indexPath.row];
    
    cell.textLabel.text       = entity.nameStr;
    cell.detailTextLabel.text = entity.phoneStr;
    
    return cell;
}

@end
