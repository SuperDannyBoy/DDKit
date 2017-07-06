//
//  AddressBookViewController.m
//  DDAddressBook
//
//  Created by SuperDanny on 15/3/27.
//  Copyright (c) 2015年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBookResultsTableViewController.h"
#import <AddressBook/AddressBook.h>

static NSString *reuseIdentifier = @"Cell";

@interface AddressBookViewController () <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

///用于快速搜索
@property (strong, nonatomic) NSMutableArray<AddressBookEntity *> *addressBookArr;
@property (strong, nonatomic) NSMutableArray<NSArray *> *sectionsArray;
@property (strong, nonatomic) NSMutableArray<AddressBookEntity *> *searchsArray;
@property (strong, nonatomic) UITableView                 *tableView;
@property (strong, nonatomic) UILocalizedIndexedCollation *collation;
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation AddressBookViewController

- (void)dealloc {
    // It works!
    [_searchController.view removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通訊錄";
    
    [self createContentView];
    
    [self readAddressBook];
    
    [self configureSections];
    
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.modalPresentationCapturesStatusBarAppearance = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - Private
- (void)createContentView {
    self.collation = [UILocalizedIndexedCollation currentCollation];
    _tableView                 = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
//    _tableView.backgroundColor = [UIColor clearColor];
//    _tableView.sectionIndexColor = [UIColorTools colorWithTheme:UIColorThemeWhite];
    if (isiOS7) {
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:_tableView];
    AddressBookResultsTableViewController *resultsVC = [[AddressBookResultsTableViewController alloc] init];
    resultsVC.tableView.delegate = self;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:resultsVC];
    _searchController.searchResultsUpdater = self;
    _searchController.delegate = self;
    self.definesPresentationContext = YES;
    //设置UISearchController的显示属性，以下2个属性默认为YES
    //搜索时，背景变暗色
//    _searchController.dimsBackgroundDuringPresentation = YES;
    //隐藏导航栏
//    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    //设置背景色
//    [[[[_searchController.searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
//    [_searchController.searchBar setBackgroundColor:[UIColor colorWithRed:0.941 green:0.937 blue:0.961 alpha:1.000]];
    _searchController.searchBar.delegate = self;
    [_searchController.searchBar sizeToFit];
    _searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
    _tableView.tableHeaderView = _searchController.searchBar;
}

#pragma mark 配置
- (void)configureSections {
    NSInteger index, sectionTitlesCount = [[self.collation sectionTitles] count];
    NSMutableArray *newSectionArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    //繁体有sectionTitles.count为89个 sectionIndexTitle.count只有52个
    for (index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionArray addObject:array];
    }
    
    for (AddressBookEntity *entity in _addressBookArr) {
        NSInteger sectionNumber = [self.collation sectionForObject:entity collationStringSelector:@selector(nameStr)];
        NSMutableArray *sectionFriends = newSectionArray[sectionNumber];
        [sectionFriends addObject:entity];
    }
    
    for (index = 0; index < sectionTitlesCount; index ++) {
        NSMutableArray *friendsArrayForSection = newSectionArray[index];
        NSArray *sortedFriendsArrayForSection = [self.collation sortedArrayFromArray:friendsArrayForSection collationStringSelector:@selector(nameStr)];
        newSectionArray[index] = sortedFriendsArrayForSection;
    }
    
    self.sectionsArray = newSectionArray;
    
    [_tableView reloadData];
}

#pragma makr - Public
#pragma mark 获取通讯录数组
+ (NSArray<AddressBookEntity *> *)getAddressBookArray {
    //获取归档数据
    NSArray *array = nil;
    array = [[self alloc] readAddressBook];
    return array;
}

#pragma mark 匹配通讯录是否有输入的联系人
+ (NSArray *)filteredContentForSearchString:(NSString *)searchString {
    NSArray *searchedArray = [NSArray arrayWithArray:[self getAddressBookArray]];
    //需要号码绝对匹配 ,在这预处理一下联系人的号码
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(AddressBookEntity *pm, NSDictionary *bindings) {
        BOOL result = NO;
        NSString *combine = @"";
        NSString *originNum = pm.phoneStr;
        
        for (int i = 0; i < originNum.length; i++) {
            char c = [originNum characterAtIndex:i];
            if (i == 0 && c == '+') {
                combine = [combine stringByAppendingFormat:@"%c",c];
            }
            if (isdigit(c)) {
                combine = [combine stringByAppendingFormat:@"%c",c];
            }
        }
        
        if ([combine hasPrefix:@"+853"]) {
            combine = [combine stringByReplacingOccurrencesOfString:@"+853" withString:@""];
        }else if ([combine hasPrefix:@"00853"]){
            combine = [combine stringByReplacingOccurrencesOfString:@"00853" withString:@""];
        }
        
        if (combine.length == 8 && [combine isEqualToString:searchString]) {
            result = YES;
        }
        
        return result;
    }];
    
    return [searchedArray filteredArrayUsingPredicate:predicate];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressBookEntity *entity = nil;
    if (self.searchController.active) {
        entity = (AddressBookEntity *)_searchsArray[indexPath.row];
    } else {
        entity = (AddressBookEntity *)_sectionsArray[indexPath.section][indexPath.row];
    }
//    if (entity.phoneStr.length>1) {
//        NSString *str = [entity.phoneStr substringToIndex:1];
//        if (entity.phoneStr.length != 8 || ![str isEqualToString:@"6"]) {
//            [AutoColoseInfoDialog popUpDialog:@"該號碼不屬於澳門號碼" withView:kAppWindow];
//            return;
//        }
//    }
    if (_block && entity) {
        _block(entity);
        [self.navigationController popViewControllerAnimated:YES];
        _searchController.active = NO;
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return 1;
    }
    return _sectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return _searchsArray.count;
    }
    return [_sectionsArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.searchController.active) {
        return 0.1;
    }
    if (self.collation.sectionTitles.count != _sectionsArray.count) {
        if (section == 0) {
            
        } else if ([_sectionsArray[section] count] == 0) {
            
        } else {
            return 30.0;
        }
    } else {
        if ([_sectionsArray[section] count] == 0) {
            
        } else {
            return 30;
        }
    }
    return 0.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.searchController.active) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
        return view;
    }
    UIView *viwe = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 30.0)];
    viwe.backgroundColor = [UIColor colorWithRed:242/255. green:242/255. blue:242/255. alpha:1];
    
    NSString *title = nil;
    if (self.collation.sectionTitles.count != _sectionsArray.count) {
        if (section == 0) {
            
        } else if ([_sectionsArray[section] count] == 0) {
            
        } else {
            title = self.collation.sectionTitles[section-1];
        }
    } else {
        if ([_sectionsArray[section] count] == 0) {
            
        } else {
            title = self.collation.sectionTitles[section];
        }
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, viwe.frame.size.width - 30.0, viwe.frame.size.height)];
    label.text = title;
//    label.textColor = [UIColorTools colorWithTheme:UIColorThemeWhite];
    [viwe addSubview:label];
    
    return viwe;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return nil;
    }
    //索引标题加个放大镜在前面
    NSArray *IndexSearchArray = [@[UITableViewIndexSearch] arrayByAddingObjectsFromArray:self.collation.sectionIndexTitles];
    return IndexSearchArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (self.searchController.active) {
        return 0;
    } else {
        if ([title isEqualToString:UITableViewIndexSearch]) {
//            [tableView setContentOffset:CGPointMake(0, -64) animated:NO];
            //index是索引条的序号。从0开始，所以第0个是放大镜。如果是放大镜坐标就移动到搜索框处
            [tableView scrollRectToVisible:_searchController.searchBar.frame animated:NO];
            return -1;
        } else {
            //繁体特殊处理
            if (self.collation.sectionTitles.count == 89) {
                if (index<14) {
                    return [self.collation sectionForSectionIndexTitleAtIndex:index-1];
                } else {
                    return [self.collation sectionForSectionIndexTitleAtIndex:index-1]+36;
                }
            } else {
                return [self.collation sectionForSectionIndexTitleAtIndex:index-1];
            }
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    AddressBookEntity *entity = nil;
    if (self.searchController.active) {
        entity = _searchsArray[indexPath.row];
    } else {
        entity = _sectionsArray[indexPath.section][indexPath.row];
    }
    
    cell.textLabel.text       = entity.nameStr;
    cell.detailTextLabel.text = entity.phoneStr;
    
//    cell.textLabel.textColor = [UIColorTools colorWithTheme:UIColorThemeWhite];
//    cell.detailTextLabel.textColor = [UIColorTools colorWithTheme:UIColorThemeWhite];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"点击了搜索按钮");
    if (searchBar.text.length) {
        [self updateSearchResultsForSearchController:self.searchController];
    }
}

#pragma mark - UISearchControllerDelegate代理
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"updateSearchResultsForSearchController");
    NSString *searchString = [self.searchController.searchBar text];
    if (searchString.length) {
        NSPredicate *preicate = [NSPredicate predicateWithFormat:@"nameStr CONTAINS[d] %@ OR phoneStr CONTAINS[c] %@", searchString, searchString];
        if (self.searchsArray) {
            [self.searchsArray removeAllObjects];
        }
        //过滤数据
        self.searchsArray = [NSMutableArray arrayWithArray:[_addressBookArr filteredArrayUsingPredicate:preicate]];
        AddressBookResultsTableViewController *tableController = (AddressBookResultsTableViewController *)self.searchController.searchResultsController;
        tableController.resultsArr = self.searchsArray;
        [tableController.tableView reloadData];
    }
}

#pragma mark -
#pragma mark 读取本地通讯录
- (NSArray<AddressBookEntity *> *)readAddressBook {
    //初始化存储联系人数组
    _addressBookArr = [NSMutableArray array];
    //新建一个通讯录类
    ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
    //获取通讯录权限
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    //获取通讯录中的所有人
    CFArrayRef peoplesRef = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    NSArray *peoples = (NSArray *)CFBridgingRelease(peoplesRef);
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:peoples.count];
    
    //提取联系人信息
    if (peoples.count) {
        [peoples enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ABRecordRef person = (__bridge  ABRecordRef)obj;
            
            //取到联系人姓名
            NSString *firstName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty) ? : @"";
            NSString *lastName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty) ? : @"";
            NSString *compositeName = [NSString stringWithFormat:@"%@ %@",lastName,firstName];
            CFRelease((__bridge CFTypeRef)(firstName));
            CFRelease((__bridge CFTypeRef)(lastName));
            compositeName = [compositeName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //取到多个号码
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            CFIndex count = ABMultiValueGetCount(phoneNumbers);
            
            if (count) {
                for (int i = 0; i<count; i++) {
                    
                    NSString *mobile = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                    
                    if (compositeName.length == 0 && i == 0) {
                        compositeName = mobile;
                    }
                    AddressBookEntity *entity = [[AddressBookEntity alloc] init];
                    entity.nameStr = compositeName;
                    entity.phoneStr = mobile;
                    [tempArray addObject:entity];
                    
                    CFRelease((__bridge CFTypeRef)(mobile));
                }
            }
            CFRelease(phoneNumbers);
        }];
    }
    _addressBookArr = tempArray;
    return _addressBookArr;
}
@end
