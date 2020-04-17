//
//  AddFriendVC.m
//  jxim
//
//  Created by yangfantao on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "AddFriendVC.h"
#import "FriendSRViewController.h"
#import "UIColor+ColorExt.h"
#import "JXIMGlobalDef.h"
#import "JXContactGroupData.h"
#import "Masonry.h"
#import "JXSystemContactCell.h"
#import "JXContactDataCell.h"

@interface AddFriendVC ()

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UISearchController *searchController;
@property(nonatomic,strong) FriendSRViewController *searchResultVC;

@property(nonatomic,copy) NSMutableArray<JXContactGroupData *> *groupData;

@end

@implementation AddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加好友";
    self.view.backgroundColor = [UIColor whiteColor];
    [self readyData];
    // Do any additional setup after loading the view.
}

-(void)readyData
{
    if (!_groupData) {
        _groupData = [[NSMutableArray<JXContactGroupData *> alloc] init];
    }
    [_groupData removeAllObjects];
    
    JXContactGroupData *systemGroup = [[JXContactGroupData alloc] initWithTitle:@"system" groupTpe:JXContactGroupTypeSystemGroup];
    [systemGroup addMember:[[JXContactMemberData alloc] initWithMemberType:JXContaceMemberTypeSystemScan] sortMember:NO];
    [systemGroup addMember:[[JXContactMemberData alloc] initWithMemberType:JXContactMemberTypeSystemInviteWXFriend] sortMember:NO];
    [systemGroup addMember:[[JXContactMemberData alloc] initWithMemberType:JXContactMemberTypeSystemPhoneContact] sortMember:NO];
    [_groupData addObject:systemGroup];
    
    [self loadUI];
    [self.tableView reloadData];
}

-(void)loadUI
{
    //搜索框+通讯录列表
    [self.view addSubview:self.searchController.searchBar];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(SearchBarHeight);
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeightForHeaderInSection(section);
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    //UITableViewIndex
//    for (UIView *view in [tableView subviews]) {
//        if ([view isKindOfClass:[NSClassFromString(@"UITableViewIndex") class]]) {
//           // 设置字体大小
//            [view setValue:[UIFont systemFontOfSize:14.0] forKey:@"_font"];
//           //设置view的大小
//            view.bounds = CGRectMake(0, 0, 20, 20);
//        }
//    }
//}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JXContactGroupData* groupData = [self.groupData objectAtIndex:indexPath.section];
    if (groupData) {
        JXContactMemberData* contactData = [groupData memberAtIndex:indexPath.row];
        if (contactData) {
            return contactData.contactDataUniProtocol.jxContactMember.rowHeight;
        }
    }
    
    return ContactRowHeight_System;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    JXContactGroupData* groupData = [self.groupData objectAtIndex:indexPath.section];
    if (groupData) {
        JXContactMemberData* contactData = [groupData memberAtIndex:indexPath.row];
        if (contactData) {
            
            NSString *reuseId = contactData.contactDataUniProtocol.jxContactMember.reuseId;
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                Class cellCls = NSClassFromString(contactData.contactDataUniProtocol.jxContactMember.cellClassName);
                cell = [[cellCls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            
            if ([cell isKindOfClass:[JXSystemContactCell class]]) {
                [(JXSystemContactCell *)cell refresh:contactData.contactDataUniProtocol.systemContactDataProvider];
            }
            else
            {
                [(JXContactDataCell *)cell refreshUser:contactData.contactDataUniProtocol.nimGroupMember];
            }
            
            return cell;
            
        }
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContaceItemCellReUseID];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JXContactGroupData* groupData = [self.groupData objectAtIndex:section];
    if (groupData) {
        return groupData.memberNum;
    }
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupData.count;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor background_lightgrey];
        //去除tableView默认的分割线
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

-(void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];

    if (_tableView) {

        if (self.searchController.active) {
            [UIView animateWithDuration:0.1f animations:^(void){
                    self.tableView.alpha = 0.0;
            } completion:nil];
        }
        else
        {
            [UIView animateWithDuration:0.1f animations:^(void){
                self.tableView.alpha = 1.0;
            } completion:nil];
        }
    }
}

-(UISearchController *)searchController
{
    if (!_searchController) {

        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultVC];
        _searchController.delegate = self.searchResultVC;
        _searchController.searchResultsUpdater = self.searchResultVC;
        _searchController.searchBar.placeholder = @"游聊号/国内手机号码";
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchController.searchBar.backgroundColor = [UIColor whiteColor];
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, SearchBarHeight);
        _searchController.searchBar.delegate = self.searchResultVC;
        if (@available(iOS 9.0, *)) {
            [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";
        }
        
        self.definesPresentationContext = YES;
    }
    return _searchController;
}

-(FriendSRViewController *)searchResultVC
{
    if (!_searchResultVC) {
        _searchResultVC = [[FriendSRViewController alloc] init];
        _searchResultVC.automaticallyAdjustsScrollViewInsets = NO;
    }
    return _searchResultVC;
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
