//
//  FriendSRViewController.m
//  jxim
//
//  Created by yangfantao on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "FriendSRViewController.h"
#import "RequestSearchAccount.h"
#import "NSString+StringExt.h"
#import "UIColor+ColorExt.h"
#import "UIFont+FontExt.h"
#import "Masonry.h"
#import <NIMKit/NIMKit.h>
#import "JXContactMemberData.h"
#import "JXContactDataCell.h"
#import "NSString+StringExt.h"
#import "JXUserDataManager.h"

@interface FriendSRViewController ()

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIImageView *imgSearchNull;
@property(nonatomic,strong) UILabel *lblSearchNull;

@property(nonatomic,strong) UISearchController *searchController;
@property(nonatomic,strong) JIMAccountSimple *searchAccount;
@property(nonatomic,strong) JXContactMemberData* memberData;
@property(nonatomic,strong) NSMutableDictionary<NSString*,JIMAccountSimple *> *searchResults;
@property(nonatomic,strong) NSMutableArray<NSString*> *failedSearch;

@end

@implementation FriendSRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchResults = [[NSMutableDictionary alloc] init];
    self.failedSearch = [[NSMutableArray alloc] init];
    
    //不能搜索自己
    [self.failedSearch addObject:JXUserDataManager.sharedInstance.userData.jim_phone];
    [self.failedSearch addObject:JXUserDataManager.sharedInstance.userData.jim_account];
    
    [self loadUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.searchController && self.searchController.isActive) {
        NSInteger statusBarHeight = STATUS_BAR_SIZE.height;
        self.tableView.contentInset = UIEdgeInsetsMake(statusBarHeight, 0, 0, 0);
    } else {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
}

-(void)loadUI
{
    //空消息提示
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.imgSearchNull];
    [self.view addSubview:self.lblSearchNull];
    
    self.imgSearchNull.hidden = YES;
    self.lblSearchNull.hidden = YES;
    
    [self.imgSearchNull mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-100);
    }];
    
    [self.lblSearchNull mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.imgSearchNull.mas_bottom);
    }];
}

-(void)dealloc
{
    _searchAccount = nil;
    _memberData = nil;
    [_searchResults removeAllObjects];
    [_failedSearch removeAllObjects];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    self.imgSearchNull.hidden = YES;
    self.lblSearchNull.hidden = YES;
    if ([NSString isNulOrEmpty:searchController.searchBar.text]) {
        self.searchAccount = nil;
    }
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    self.searchController = searchController;
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    
}

-(void)setSearchAccount:(JIMAccountSimple *)searchAccount
{
    _searchAccount = searchAccount;
    if (self.searchAccount) {
        
        self.imgSearchNull.hidden = YES;
        self.lblSearchNull.hidden = YES;
        
        NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:self.searchAccount.nim_accid option:nil];
        self.memberData = [[JXContactMemberData alloc] initWithNimKitInfo:info memberType:JXContactMemberTypeNIMUser];
    }
    else
    {
        self.imgSearchNull.hidden = NO;
        self.lblSearchNull.hidden = NO;
        
        self.memberData = nil;
    }
    
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([NSString isNulOrEmpty:searchBar.text]) {
        return;
    }

    _searchAccount = nil;
    _memberData = nil;
    
    if ([self.failedSearch containsObject:searchBar.text]) {
        self.searchAccount = nil;
        return;
    }
    
    if ([self.searchResults.allKeys containsObject:searchBar.text]) {
        self.searchAccount = [self.searchResults objectForKey:searchBar.text];
    }
    else
    {
        RequestSearchAccount *api = [[RequestSearchAccount alloc] initWithSearchContent:searchBar.text];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            if (0 == api.respStatus) {
                self.searchAccount = api.account;
                if (self.searchAccount) {
                    [self.searchResults setValue:api.account forKey:searchBar.text];
                }
                else
                {
                    [self.failedSearch addObject:searchBar.text];
                }
                return;
            }
            
            [self.failedSearch addObject:searchBar.text];
            self.searchAccount = nil;
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            self.searchAccount = nil;
            
        }];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.memberData) {
        return self.memberData.contactDataUniProtocol.jxContactMember.rowHeight;
    }
    return 0 == indexPath.section ? ContactRowHeight_System : NIMContactDataRowHeight;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (self.memberData) {
        
        NSString *reuseId = self.memberData.contactDataUniProtocol.jxContactMember.reuseId;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        
        if (!cell) {
            Class cellCls = NSClassFromString(self.memberData.contactDataUniProtocol.jxContactMember.cellClassName);
            cell = [[cellCls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        }

        [(JXContactDataCell *)cell refreshUser:self.memberData.contactDataUniProtocol.nimGroupMember];

        return cell;
        
    }
    
    return nil;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.memberData) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.memberData) {
        return 1;
    }
    return 0;
}

-(UIImageView *)imgSearchNull
{
    if (!_imgSearchNull) {
        _imgSearchNull = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_account_null"]];
    }
    return _imgSearchNull;
}

-(UILabel *)lblSearchNull
{
    if (!_lblSearchNull) {
        _lblSearchNull = [[UILabel alloc] init];
        _lblSearchNull.font = [UIFont fontBackgroundTip];
        _lblSearchNull.textColor = [UIColor text_whitebg_grey_light];
        _lblSearchNull.text = @"暂无搜索结果";
    }
    return _lblSearchNull;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SearchBarHeight, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor background_lightgrey];
        //_tableView.contentInset = UIEdgeInsetsMake(SearchBarHeight, 0, 0, 0);
        //去除tableView默认的分割线
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
