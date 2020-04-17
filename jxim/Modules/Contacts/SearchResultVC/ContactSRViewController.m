//
//  ContactSRViewController.m
//  jxim
//
//  Created by yangfantao on 2020/3/29.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "ContactSRViewController.h"
#import "JXIMGlobalDef.h"
#import "JXContactDef.h"
#import "JXContactGroupData.h"
#import "Masonry.h"
#import "UIColor+ColorExt.h"
#import "JXSearchContactManager.h"
#import "UIFont+FontExt.h"

@interface ContactSRViewController ()

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) JXContactGroupData *searchContactData;
@property (nonatomic,strong) UIImageView *imgEmptyMsg;
@property (nonatomic,strong) UILabel *lblEmptyMsg;

@end

@implementation ContactSRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    self.view.backgroundColor = [UIColor systemRedColor];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)loadUI
{
    //空消息提示
    [self.view addSubview:self.imgEmptyMsg];
    [self.view addSubview:self.lblEmptyMsg];
    self.imgEmptyMsg.hidden = YES;
    self.lblEmptyMsg.hidden = YES;
    
    [self.imgEmptyMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-100);
    }];
    
    [self.lblEmptyMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.imgEmptyMsg.mas_bottom);
    }];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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


-(UIImageView *)imgEmptyMsg
{
    if (!_imgEmptyMsg) {
        _imgEmptyMsg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptymsg"]];
    }
    return _imgEmptyMsg;
}

-(UILabel *)lblEmptyMsg
{
    if (!_lblEmptyMsg) {
        _lblEmptyMsg = [[UILabel alloc] init];
        _lblEmptyMsg.font = [UIFont fontBackgroundTip];
        _lblEmptyMsg.textColor = [UIColor text_whitebg_grey_light];
        _lblEmptyMsg.text = @"暂无搜索结果";
    }
    return _lblEmptyMsg;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    
}
- (void)didDismissSearchController:(UISearchController *)searchController
{
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    NSInteger groupNum = [JXContactManager.sharedInstance countOfGroup];
//    if (section == groupNum - 1) {
//        return 40.0f;
//    }
    return -1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    NSInteger groupNum = [JXContactManager.sharedInstance countOfGroup];
//    if (section == groupNum - 1) {
//        return _lblFriendCount;
//    }
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
    return NIMContactDataRowHeight;
//    id<JXContactDataUniProtocol> contactData = [JXContactManager.sharedInstance contactDataUniProtocolOfIndexPath:indexPath];
//    if (!contactData) {
//        return 0 == indexPath.section ? ContactRowHeight_System : NIMContactDataRowHeight;
//    }
//    return contactData.jxContactMember.rowHeight;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return nil;
//    id<JXContactDataUniProtocol> contactData = [JXContactManager.sharedInstance contactDataUniProtocolOfIndexPath:indexPath];
//    if (!contactData)return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContaceItemCellReUseID];
//
//    NSString *reuseId = contactData.jxContactMember.reuseId;
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
//    if (!cell) {
//        Class cellCls = NSClassFromString(contactData.jxContactMember.cellClassName);
//        cell = [[cellCls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
//    }
//
//    if ([cell isKindOfClass:[JXSystemContactCell class]]) {
//        [(JXSystemContactCell *)cell refresh:contactData.systemContactDataProvider];
//    }
//    else
//    {
//        [(JXContactDataCell *)cell refreshUser:contactData.nimGroupMember];
//    }
//
//    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
//    NSInteger rowsNum = [JXContactManager.sharedInstance memberCountInGroup:section];
//    return rowsNum;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
//    return [JXContactManager.sharedInstance countOfGroup];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    return @"";
//    return [JXContactManager.sharedInstance titleOfGroup:section];
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
