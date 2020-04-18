//
//  JXContactsVC.m
//  jxim
//
//  Created by yangfantao on 2020/3/22.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXContactsVC.h"
#import "JXIMGlobalDef.h"
#import "UIColor+ColorExt.h"
#import "UIFont+FontExt.h"
#import "Masonry.h"
#import "JXContactManager.h"
#import "JXSystemContactCell.h"
#import "JXContactDataCell.h"
#import "FSVerticallyAlignedLabel.h"
#import "ContactSRViewController.h"
#import "AddFriendVC.h"

@interface JXContactsVC ()

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UISearchController *searchController;
@property(nonatomic,strong) ContactSRViewController *searchResultVC;
@property(nonatomic,strong) FSVerticallyAlignedLabel *lblFriendCount;

@end

@implementation JXContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readyData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"通讯录";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
}

-(void)readyData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [JXContactManager.sharedInstance loadContact];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadUI];
            [self reloadContactData];
        });
    });
}

-(void)refresh
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [JXContactManager.sharedInstance loadContact];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadContactData];
        });
    });
}

- (void)reloadContactData
{
    [self.tableView reloadData];
    self.lblFriendCount.text = [NSString stringWithFormat:@"%ld位联系人",[JXContactManager.sharedInstance nimUserCount]];
}

-(void)loadUI
{
    //导航栏定制
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_barbutton_addcontact"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                            action:@selector(onAddContact)];
    //搜索框+通讯录列表
    [self.view addSubview:self.searchController.searchBar];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(SearchBarHeight);
    }];
}

-(void) onAddContact
{
    [self.navigationController pushViewController:[[AddFriendVC alloc] init] animated:YES];
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.lblFriendCount;
        self.tableView.backgroundColor = [UIColor background_lightgrey];
        //段落背景
        [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        //段落标题颜色
        [self.tableView setSectionIndexColor:[UIColor text_greybg_darkgrey]];
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
        _searchController.searchBar.placeholder = @"搜索";
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchController.searchBar.backgroundColor = [UIColor whiteColor];
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, SearchBarHeight);
        
        if (@available(iOS 9.0, *)) {
            [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";
        }
        
        self.definesPresentationContext = YES;
    }
    return _searchController;
}

-(ContactSRViewController *)searchResultVC
{
    if (!_searchResultVC) {
        _searchResultVC = [[ContactSRViewController alloc] init];
        _searchResultVC.automaticallyAdjustsScrollViewInsets = NO;
    }
    return _searchResultVC;
}

// 好友数量
-(FSVerticallyAlignedLabel *)lblFriendCount
{
    if (!_lblFriendCount) {
        _lblFriendCount = [[FSVerticallyAlignedLabel alloc] init];
        _lblFriendCount.font = [UIFont fontBackgroundTip];
        _lblFriendCount.textColor = [UIColor text_whitebg_grey_light];
        _lblFriendCount.text = @"0位联系人";
        _lblFriendCount.textAlignment = NSTextAlignmentCenter;
        _lblFriendCount.verticalAlignment = VerticalAlignmentMiddle;
    }
    return _lblFriendCount;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeightForHeaderInSection(section);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger groupNum = [JXContactManager.sharedInstance countOfGroup];
    if (section == groupNum - 1) {
        return 40.0f;
    }
    return -1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSInteger groupNum = [JXContactManager.sharedInstance countOfGroup];
    if (section == groupNum - 1) {
        return _lblFriendCount;
    }
    return nil;
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
    id<JXContactDataUniProtocol> contactData = [JXContactManager.sharedInstance contactDataUniProtocolOfIndexPath:indexPath];
    if (!contactData) {
        return 0 == indexPath.section ? ContactRowHeight_System : NIMContactDataRowHeight;
    }
    return contactData.jxContactMember.rowHeight;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    id<JXContactDataUniProtocol> contactData = [JXContactManager.sharedInstance contactDataUniProtocolOfIndexPath:indexPath];
    if (!contactData)return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContaceItemCellReUseID];
    
    NSString *reuseId = contactData.jxContactMember.reuseId;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        Class cellCls = NSClassFromString(contactData.jxContactMember.cellClassName);
        cell = [[cellCls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    if ([cell isKindOfClass:[JXSystemContactCell class]]) {
        [(JXSystemContactCell *)cell refresh:contactData.systemContactDataProvider];
    }
    else
    {
        [(JXContactDataCell *)cell refreshUser:contactData.nimGroupMember];
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rowsNum = [JXContactManager.sharedInstance memberCountInGroup:section];
    return rowsNum;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [JXContactManager.sharedInstance countOfGroup];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    return [JXContactManager.sharedInstance titleOfGroup:section];
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView;
{
    return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
            [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
{
    if(index == 0)
    {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    return [JXContactManager.sharedInstance groupIdxOfTtitle:title];
}

@end
