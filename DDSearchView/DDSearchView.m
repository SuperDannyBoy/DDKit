//
//  DDSearchView.m
//  OShopping
//
//  Created by SuperDanny on 16/3/22.
//  Copyright © 2016年 MacauIT. All rights reserved.
//

#import "DDSearchView.h"
#import "AppDelegate.h"
#import "PopoverView.h"
#import "ShoppingSearchResultViewController.h"

///搜索商品模型
@interface SearchGoodModel : NSObject

@property (nonatomic, copy  ) NSString  *goods_name;
@property (nonatomic, assign) NSInteger goods_id;

@end

@implementation SearchGoodModel

MJCodingImplementation

@end

///搜索店铺模型
@interface SearchShopModel : NSObject

@property (nonatomic, copy  ) NSString  *store_name;
@property (nonatomic, assign) NSInteger store_id;

@end

@implementation SearchShopModel

MJCodingImplementation

@end

///搜索类型
typedef NS_ENUM(NSUInteger, SearchType) {
    ///搜索商品
    SearchTypeGoods,
    ///搜索商店
    SearchTypeShops,
};

///显示类型
typedef NS_ENUM(NSUInteger, ShowType) {
    ///显示搜索历史
    ShowTypeHistory,
    ///显示搜索内容
    ShowTypeSearchData,
};

#define kGoodsSearchHistory @"GoodsSearchHistory"
#define kShopsSearchHistory @"ShopsSearchHistory"

@interface DDSearchView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIButton    *styleBtn;
@property (nonatomic, strong) UITableView *tb;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) NSArray     *popTitleArray;
@property (nonatomic, strong) NSArray     *searchArray;
@property (nonatomic, strong) NSArray     *dataArray;
///商品搜索历史
@property (nonatomic, strong) NSMutableDictionary *goodsHistroyDic;
///店铺搜索历史
@property (nonatomic, strong) NSMutableDictionary *shopsHistroyDic;

@property (nonatomic, assign) SearchType searchType;
@property (nonatomic, assign) ShowType   showType;
@property (nonatomic, assign) ViewType   viewType;
///商家ID  -1全部
@property (nonatomic, copy  ) NSString   *store_id;

@end

@implementation DDSearchView
- (instancetype)initWithViewType:(ViewType)type storeId:(NSString *)store_id {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        self.viewType = type;
        self.store_id = store_id;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    WEAKSELF
    _searchType  = SearchTypeGoods;
    _showType    = ShowTypeHistory;
    _searchArray = [NSArray array];
    _dataArray   = [NSArray array];
    
    NSArray *tempArr = nil;
    if (_viewType == ViewTypeAlone) {
        tempArr = @[NSLocalizedString(@"商品", nil)];
    } else {
        tempArr = @[NSLocalizedString(@"商品", nil),
                    NSLocalizedString(@"店鋪", nil)];
    }
    self.popTitleArray = tempArr;
    
    self.goodsHistroyDic  = [NSMutableDictionary dictionaryWithDictionary:[[TMCache sharedCache] objectForKey:kGoodsSearchHistory]];
    self.shopsHistroyDic  = [NSMutableDictionary dictionaryWithDictionary:[[TMCache sharedCache] objectForKey:kShopsSearchHistory]];
    
    CGFloat leftEdge       = _viewType == ViewTypeAlone ? 30 : 25;
    CGFloat topEdge        = 5;
    CGFloat cancelBtnWidth = 50;
    CGFloat tfWidth        = KScreenWidth-leftEdge-cancelBtnWidth;
    CGFloat tfHeight       = kNavBarHeight-2*topEdge;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth, kNavBarHeight)];
    bgView.userInteractionEnabled = YES;
    bgView.image = [UIImage imageWithColor:kNavigationBackgroundImageColor];
    [self addSubview:bgView];
    
    //styleView
    CGFloat styleViewWidth = /*_viewType == ViewTypeAlone ? 0 : */65+3;
    CGFloat styleBtnWidth  = /*_viewType == ViewTypeAlone ? 0 : */55;
    UIView *styleView      = [[UIView alloc] initWithFrame:CGRectMake(0, 0, styleViewWidth, tfHeight)];
    _styleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, styleBtnWidth, tfHeight)];
    _styleBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_styleBtn setTitle:[_popTitleArray firstObject] forState:UIControlStateNormal];
    [_styleBtn setTitleColor:[UIColorTools colorWithTheme:UIColorThemeGray] forState:UIControlStateNormal];
    [_styleBtn addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [styleView addSubview:_styleBtn];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_styleBtn.frame) - 6, 0, styleViewWidth-styleBtnWidth, tfHeight)];
    img.contentMode  = UIViewContentModeScaleAspectFit;
    img.image        = [UIImage imageNamed:@"arrow_down_gray"];
    [styleView addSubview:img];
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(leftEdge, topEdge, tfWidth, tfHeight)];
    _searchField.clipsToBounds      = YES;
    _searchField.layer.cornerRadius = 4.5;
    _searchField.returnKeyType      = UIReturnKeySearch;
    _searchField.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _searchField.leftViewMode       = UITextFieldViewModeAlways;
    _searchField.leftView           = _viewType == ViewTypeAlone ? [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, tfHeight)] : styleView;
    _searchField.delegate           = self;
    _searchField.backgroundColor    = [UIColorTools colorWithTheme:UIColorThemeWhite];
    _searchField.textColor          = [UIColorTools colorWithTheme:UIColorThemeBlack];
    _searchField.placeholder        = NSLocalizedString(@"請輸入關鍵字", nil);
    _searchField.font = _styleBtn.titleLabel.font;
    
    //添加监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChange:) name:UITextFieldTextDidChangeNotification object:_searchField];
    [bgView addSubview:_searchField];
    
    //cancel
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_searchField.frame), 0, cancelBtnWidth, kNavBarHeight)];
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColorTools colorWithTheme:UIColorThemeWhite] forState:UIControlStateNormal];
    [cancelBtn bk_addEventHandler:^(id sender) {
        [weakSelf.searchField resignFirstResponder];
        [weakSelf removeFromSuperview];
    } forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    //tableview
    [self addSubview:self.tb];
    
    [_searchField becomeFirstResponder];
}

- (void)showpopover:(id)sender {
    UIButton *showBtn = sender;
    PopoverView *popoverView = [PopoverView new];
    popoverView.menuTitles   = _popTitleArray;
    typeof(self) __weak weakSelf = self;
    [popoverView showFromView:showBtn selected:^(NSInteger index) {
        [weakSelf.styleBtn setTitle:popoverView.menuTitles[index] forState:UIControlStateNormal];
        weakSelf.searchType = index;
        [weakSelf changeFooter];
        //判断是否查询网络数据
        if (weakSelf.searchField.text.length) {
            if (weakSelf.searchType == SearchTypeGoods) {
                [weakSelf requestShoppingManage_Goods_GetGoodsName:weakSelf.searchField.text];
            } else {
                [weakSelf requestShoppingManage_store_GetStoreName:weakSelf.searchField.text];
            }
        } else {
            [weakSelf.tb reloadData];
        }
    }];
}

- (void)open:(id)sender {
    [self showpopover:sender];
}

#pragma mark - Getter
- (UITableView *)tb {
    WEAKSELF
    if (!_tb) {
        _tb = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+20, KScreenWidth, KScreenHeight-kNavBarHeight-20) style:UITableViewStyleGrouped];
        _tb.delegate   = self;
        _tb.dataSource = self;
        _tb.tableFooterView = [UIView new];
        _tb.tableFooterView = ({
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30+44)];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, KScreenWidth-2*20, 40)];
            [btn setTitle:NSLocalizedString(@"清除歷史記錄", nil)
                 forState:UIControlStateNormal];
            [btn setTitleColor:[UIColorTools colorWithTheme:UIColorThemeWhite]
                      forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColorTools colorWithTheme:UIColorThemeRed]]
                           forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColorTools colorWithTheme:UIColorThemeButtonDisabled]]
                           forState:UIControlStateDisabled];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = kButtonCornerRadius;
            [btn bk_addEventHandler:^(id sender) {
                [weakSelf clearHistory];
            } forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btn];
            bgView;
        });
        [_tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tb;
}

#pragma mark -
- (void)setShowType:(ShowType)showType {
    _showType = showType;
    [self.tb reloadData];
}

#pragma mark - 清除歷史記錄
- (void)clearHistory {
    //清除记录，并且将清除按钮隐藏
    if (_searchType == SearchTypeGoods) {
        [[TMCache sharedCache] removeObjectForKey:kGoodsSearchHistory];
        [_goodsHistroyDic removeAllObjects];
    } else {
        [[TMCache sharedCache] removeObjectForKey:kShopsSearchHistory];
        [_shopsHistroyDic removeAllObjects];
    }
    _tb.tableFooterView.hidden = YES;
    [self.tb reloadData];
}

#pragma mark - 保存歷史記錄
- (void)saveHistory {
    if (_searchType == SearchTypeGoods) {
        [[TMCache sharedCache] setObject:_goodsHistroyDic forKey:kGoodsSearchHistory];
    } else {
        [[TMCache sharedCache] setObject:_shopsHistroyDic forKey:kShopsSearchHistory];
    }
}

#pragma mark - 更新底部清除历史记录按钮
- (void)changeFooter {
    //判断是否隐藏清除历史记录按钮
    if (_showType == ShowTypeHistory) {
        if (_searchType == SearchTypeGoods) {
            _tb.tableFooterView.hidden = (_goodsHistroyDic.count == 0);
        } else {
            _tb.tableFooterView.hidden = (_shopsHistroyDic.count == 0);
        }
    } else {
        _tb.tableFooterView.hidden = YES;
    }
}

#pragma mark - 进入搜索列表界面
- (void)jumpToSearchViewControllerWithKeyword:(NSString *)keyword {
    if (keyword.length) {
        [_searchField resignFirstResponder];
        ShoppingSearchResultViewController *vc = [[ShoppingSearchResultViewController alloc] init];
        vc.searchType = _searchType;
        vc.store_id   = _store_id;
        vc.keyword    = keyword;
        [CurrentViewController.navigationController pushViewController:vc animated:YES];
        [self removeFromSuperview];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = 0;
    if (_showType == ShowTypeHistory) {
        count = _searchType == SearchTypeGoods ? [_goodsHistroyDic allKeys].count : [_shopsHistroyDic allKeys].count;
    } else {
        count = _dataArray.count;
    }
    if (_searchField.text.length) {
        [self configBlankPage:EaseBlankPageTypeView_Default hasData:count>0 hasError:NO reloadButtonBlock:nil];
    } else {
        [self configBlankPage:EaseBlankPageTypeView_NoSearchData hasData:count>0 hasError:NO reloadButtonBlock:nil];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle      = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColorTools colorWithTheme:UIColorThemeBlack];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    NSString *titleStr = [NSString string];
    
    if (_showType == ShowTypeHistory) {
        if (_searchType == SearchTypeGoods) {
            titleStr = [_goodsHistroyDic allKeys][indexPath.row];
        } else {
            titleStr = [_shopsHistroyDic allKeys][indexPath.row];
        }
    } else {
        id model = _dataArray[indexPath.row];
        if (_searchType == SearchTypeGoods) {
            titleStr = ((SearchGoodModel *)model).goods_name;
        } else {
            titleStr = ((SearchShopModel *)model).store_name;
        }
    }
    cell.textLabel.text = titleStr;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *keyword = [NSString string];
    if (_showType == ShowTypeHistory) {
        if (_searchType == SearchTypeGoods) {
            keyword = [_goodsHistroyDic allKeys][indexPath.row];
            NSLog(@"点击商品搜索历史：%@", keyword);
        } else {
            keyword = [_shopsHistroyDic allKeys][indexPath.row];
            SearchShopModel *model = _shopsHistroyDic[keyword];
            _store_id = [NSString stringWithFormat:@"%ld", (long)model.store_id];
            NSLog(@"点击店铺搜索历史：%@", keyword);
        }
    } else {
        if (_searchType == SearchTypeGoods) {
            SearchGoodModel *model = _dataArray[indexPath.row];
            keyword = model.goods_name;
            NSLog(@"点击搜索商品：%@", keyword);
            //更新歷史記錄
            [_goodsHistroyDic setObject:keyword forKey:keyword];
        } else {
            SearchShopModel *model = _dataArray[indexPath.row];
            keyword = model.store_name;
            _store_id = [NSString stringWithFormat:@"%ld", (long)model.store_id];
//            keyword = ((SearchShopModel *)_dataArray[indexPath.row]).store_name;
            NSLog(@"点击搜索店铺：%@", keyword);
            //更新歷史記錄
            [_shopsHistroyDic setObject:model forKey:keyword];
        }
    }
    //保存历史记录
    [self saveHistory];
    //进入搜索列表界面
    [self jumpToSearchViewControllerWithKeyword:keyword];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - NSNotification
- (void)textFieldValueChange:(NSNotification *)not {
    UITextField *txt = not.object;
    if (txt.text.length) {
        self.showType = ShowTypeSearchData;
        _tb.tableFooterView.hidden = YES;
        if (_searchType == SearchTypeGoods) {
            [self requestShoppingManage_Goods_GetGoodsName:txt.text];
        } else {
            [self requestShoppingManage_store_GetStoreName:txt.text];
        }
    } else {
        //        [self.dataArray removeAllObjects];
        self.showType = ShowTypeHistory;
        [self changeFooter];
        [_tb reloadData];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        [self changeFooter];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //删操作
    if (string.length == 0) {
        if (textField.text.length == 1) {
            self.dataArray = [NSArray array];
            [self.tb reloadData];
        } else {
            NSString *preString = [NSString stringWithFormat:@"*%@*",[textField.text substringToIndex:range.location]];
            NSPredicate *predicate = nil;
            if (_searchType == SearchTypeGoods) {
                predicate = [NSPredicate predicateWithFormat:@"goods_name LIKE[cd] %@", preString];
            } else {
                predicate = [NSPredicate predicateWithFormat:@"store_name LIKE[cd] %@", preString];
            }
            
            NSArray *temp = [self.searchArray filteredArrayUsingPredicate:predicate];
            self.dataArray = [NSArray arrayWithArray:temp];
            [self.tb reloadData];
        }
    } else {
        //第一次输入(string 可能是多个字符)
        if (textField.text.length == 0) {
//            if (_searchType == SearchTypeGoods) {
//                [self requestShoppingManage_Goods_GetGoodsName:string];
//            } else {
//                [self requestShoppingManage_store_GetStoreName:string];
//            }
        } else {
            NSString *preString = [NSString stringWithFormat:@"*%@*",[textField.text stringByAppendingString:string]];
            NSPredicate *predicate = nil;
            if (_searchType == SearchTypeGoods) {
                predicate = [NSPredicate predicateWithFormat:@"goods_name LIKE[cd] %@", preString];
            } else {
                predicate = [NSPredicate predicateWithFormat:@"store_name LIKE[cd] %@", preString];
            }
            self.dataArray = [self.searchArray filteredArrayUsingPredicate:predicate];
            [self.tb reloadData];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_searchField.text.length) {
        [self jumpToSearchViewControllerWithKeyword:_searchField.text];
    } else {
        [_searchField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Request
#pragma mark 模糊查询商家名称
- (void)requestShoppingManage_store_GetStoreName:(NSString *)string {
    WEAKSELF
    NSString *keyword = @"";
//    if (string.length == 1) {
        keyword = string;
//    } else {
//        keyword = [string substringToIndex:1];
//    }
    [[AFRequest shareAFReques] requestMethod:@"ShoppingManage_store_GetStoreName"
                               withParamters:@[@{@"store_name" : keyword}]
                                servicesType:kWebServiceTypeOShopping
                                      tarGet:self
                                      Custom:NO
                                 andUserInfo:AFNet_UserInfo(@"ShoppingManage_store_GetStoreName")
                             successedMethod:^(NSDictionary *dic) {
                                 weakSelf.showType = ShowTypeSearchData;
                                 
                                 [weakSelf changeFooter];
                                 
                                 NSString *flag = [Tools filterNULLValue:dic[@"Flag"]];
                                 if ([flag isEqualToString:@"1"]) {
                                     NSArray *array = dic[@"Object"];
                                     if (array.count != 0) {
                                         NSMutableArray *newArray = [NSMutableArray array];
                                         [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                             NSDictionary *dic = obj;
                                             SearchShopModel *model = [SearchShopModel mj_objectWithKeyValues:dic];
                                             [newArray addObject:model];
                                         }];
                                         if (string.length == 1) {
                                             weakSelf.dataArray = newArray;
                                             weakSelf.searchArray = newArray;
                                         } else {
                                             weakSelf.searchArray = newArray;
                                             NSString *preString = [NSString stringWithFormat:@"*%@*", string];
                                             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"store_name LIKE[cd] %@",preString];
                                             weakSelf.dataArray = [weakSelf.searchArray filteredArrayUsingPredicate:predicate];
                                         }
                                         [weakSelf.tb reloadData];
                                         return;
                                     }
//                                     [AutoColoseInfoDialog popUpDialog:NSLocalizedString(@"查詢不到數據", nil) withView:kAppWindow];
                                 } else {
                                     [AutoColoseInfoDialog popUpDialog:dic[@"Decription"]
                                                              withView:kAppWindow];
//                                     [[[OSAlertView alloc] initWithTitle:@""
//                                                                 message:dic[@"Decription"]
//                                                           cancellButton:nil
//                                                            buttonTitles:@[NSLocalizedString(@"確定", nil)]] show];
                                 }
                             } failedMedthod:^(NSString *string) {
                             }];
}

#pragma mark 模糊查询商品名称
- (void)requestShoppingManage_Goods_GetGoodsName:(NSString *)string {
    WEAKSELF
    NSString *keyword = @"";
//    if (string.length == 1) {
        keyword = string;
//    } else {
//        keyword = [string substringToIndex:1];
//    }
    
    NSString *store_id = _store_id ? _store_id :@"-1";
    
    [[AFRequest shareAFReques] requestMethod:@"ShoppingManage_Goods_GetGoodsName"
                               withParamters:@[@{@"goods_name" : keyword},
                                               @{@"store_id" : store_id}]
                                servicesType:kWebServiceTypeOShopping
                                      tarGet:self
                                      Custom:NO
                                 andUserInfo:AFNet_UserInfo(@"ShoppingManage_Goods_GetGoodsName")
                             successedMethod:^(NSDictionary *dic) {
                                 weakSelf.showType = ShowTypeSearchData;
                                 
                                 [weakSelf changeFooter];
                                 
                                 NSString *flag = [Tools filterNULLValue:dic[@"Flag"]];
                                 if ([flag isEqualToString:@"1"]) {
                                     NSArray *array = dic[@"Object"];
                                     if (array.count != 0) {
                                         NSMutableArray *newArray = [NSMutableArray array];
                                         [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                             NSDictionary *dic = obj;
                                             SearchGoodModel *model = [SearchGoodModel mj_objectWithKeyValues:dic];
                                             [newArray addObject:model];
                                         }];
                                         if (string.length == 1) {
                                             weakSelf.dataArray = newArray;
                                             weakSelf.searchArray = newArray;
                                         } else {
                                             weakSelf.searchArray = newArray;
                                             NSString *preString = [NSString stringWithFormat:@"*%@*", string];
                                             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"goods_name LIKE[cd] %@",preString];
                                             weakSelf.dataArray = [weakSelf.searchArray filteredArrayUsingPredicate:predicate];
                                         }
                                         [weakSelf.tb reloadData];
                                         return;
                                     }
//                                     [AutoColoseInfoDialog popUpDialog:NSLocalizedString(@"查詢不到數據", nil) withView:kAppWindow];
                                 } else {
                                     [AutoColoseInfoDialog popUpDialog:dic[@"Decription"]
                                                              withView:kAppWindow];
                                     //                                     [[[OSAlertView alloc] initWithTitle:@""
                                     //                                                                 message:dic[@"Decription"]
                                     //                                                           cancellButton:nil
                                     //                                                            buttonTitles:@[NSLocalizedString(@"確定", nil)]] show];
                                 }
                             } failedMedthod:^(NSString *string) {
                             }];
}

@end
