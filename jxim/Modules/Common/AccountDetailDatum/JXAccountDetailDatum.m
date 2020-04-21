//
//  JXAccountDetailDatum.m
//  jxim
//
//  Created by yangfantao on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXAccountDetailDatum.h"
#import <NIMSDK/NIMSDK.h>
#import <SVProgressHUD.h>
#import "JXMinePortraitView.h"
#import "UIColor+ColorExt.h"
#import "UIFont+FontExt.h"
#import "UITableViewCell+CellExt.h"
#import "Masonry.h"
#import "JXMineDef.h"
#import "JXAccountDetailSetAliasVC.h"
#import "JXSessionViewController.h"
#import "JXUserDataManager.h"

@interface JXAccountDetailDatum ()

@property(nonatomic,copy) NSString *nimAccId;

@property(nonatomic,strong) JXMinePortraitView *portraitView;
@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UILabel *phoneLbl;

@property(nonatomic,strong) UIButton *addFriendBtn;
@property(nonatomic,strong) UIButton *sendMsgBtn;

@property (nonatomic,assign) BOOL isFriend;
@property(nonatomic,strong) NIMUser *user;

@property(nonatomic,strong) UIView *requestView;
@property(nonatomic,strong) UITextField *requestMsgTxf;

@end

@implementation JXAccountDetailDatum

-(instancetype)initWithNIMAccId:(NSString *)nimAccId
{
    if (self = [super init]) {
        _nimAccId = nimAccId;
        //_nimAccId = @"yangfantao";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self loadUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationItem.title = @"详细资料";
    [self setNavigationBarClear:YES];
    [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self setNavigationBarClear:NO];
}

- (void)loadData{
    self.isFriend = [NIMSDK.sharedSDK.userManager isMyFriend:self.nimAccId];
    self.user = [NIMSDK.sharedSDK.userManager userInfo:self.nimAccId];
    [self.view addSubview:[self getTable]];
    if (self.user.userInfo == nil) {
        [SVProgressHUD show];
        [NIMSDK.sharedSDK.userManager fetchUserInfos:@[self.nimAccId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
            [SVProgressHUD dismiss];
            if (error == nil) {
                self.user = [NIMSDK.sharedSDK.userManager userInfo:self.nimAccId];
                [self.tableView reloadData];
                [self.portraitView refreshData: self.user];
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"获取用户信息失败"];
            }
        }];
    }
}

- (void)loadUI{
    [self.view addSubview:[self getTable]];
    
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(-(NotchHeight + navigationBarHeight));
        make.bottom.and.left.and.right.mas_equalTo(0);
    }];
    
    [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(JXPortraitCellHeight);
        make.width.and.centerX.mas_equalTo(self.tableView);
        make.top.mas_equalTo(self.tableView).with.offset(-JXPortraitCellHeight);
    }];
}


#pragma mark - Action

- (void)onAddFriend: (UIButton *)btn{
    if (!btn.tag) {
        NSLog(@"tag: %ld", (long)btn.tag);
        [self showAddFriendRequestView];
        return;
    }
    NIMUserRequest *request = [NIMUserRequest new];
    request.userId = self.nimAccId;
    request.operation = NIMUserOperationRequest;
    request.message = self.requestMsgTxf.text;
    NSString *successText = request.operation == NIMUserOperationAdd ? @"添加成功" : @"请求成功";
    NSString *failedText =  request.operation == NIMUserOperationAdd ? @"添加失败" : @"请求失败";
    
    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (!error) {
            [SVProgressHUD showSuccessWithStatus: successText];
            [self dismissRequestView];
            [self refresh];
        }
        else {
            [SVProgressHUD showErrorWithStatus: failedText];
        }
    }];
}

- (void)onSendMsg{
    UINavigationController *nav = self.navigationController;
    NIMSession *session = [NIMSession session:self.user.userId type:NIMSessionTypeP2P];
    JXSessionViewController *vc = [[JXSessionViewController alloc] initWithSession:session];
    [nav pushViewController:vc animated:YES];
    UIViewController *root = nav.viewControllers[0];
    nav.viewControllers = @[root,vc];
}

- (void)onSelectSetAliasCell{
    JXAccountDetailSetAliasVC *vc = [[JXAccountDetailSetAliasVC alloc] initWithNIMAccId:self.nimAccId];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 获取元素

- (JXMinePortraitView *) getPortrait{
    if (!self.portraitView) {
        self.portraitView = [[JXMinePortraitView alloc] initWithFrame:CGRectZero];
        [self.portraitView refreshData: self.user];
    }
    return self.portraitView;
}

- (UITableView *)getTable{
    if (!self.tableView) {
         self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //段落背景
        //[self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        //段落标题颜色
        [self.tableView setSectionIndexColor:[UIColor text_greybg_darkgrey]];
        //去除tableView默认的分割线
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //禁止滑动
        //[self.tableView setScrollEnabled:NO];

        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
        [self.tableView addSubview: [self getPortrait]];
        //取消安全区限制
        if (@available(iOS 11.0, *))    {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        _tableView.contentInset = UIEdgeInsetsMake(JXPortraitCellHeight, 0, 0, 0);
    }
    return self.tableView;
}

- (UILabel *)getPhoneLbl{
    if (!_phoneLbl) {
        _phoneLbl = [UILabel new];
        [_phoneLbl setFont:[UIFont systemFontOfSize:InputeFontSize]];
        [_phoneLbl setText: self.user.ext];
    }
    return _phoneLbl;
}


- (UIButton *)getAddFriendBtn{
    if (!self.addFriendBtn) {
        UIButton *button = [[UIButton alloc] init];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0f];
        [button.titleLabel setFont:[UIFont loginRegister_registerButton]];
        [button setTitle:@"添加好友" forState:UIControlStateNormal];
        [button setTag:0];
        button.backgroundColor = [UIColor systemBlueColor];
        [button addTarget:self action:@selector(onAddFriend:) forControlEvents:UIControlEventTouchUpInside];
        self.addFriendBtn = button;
    }
    return self.addFriendBtn;
}

- (UIButton *)getSendMsgBtn{
    if (!self.sendMsgBtn) {
        UIButton *button = [[UIButton alloc] init];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0f];
        [button.titleLabel setFont:[UIFont loginRegister_registerButton]];
        [button setTitle:@"发消息" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor systemBlueColor];
        [button addTarget:self action:@selector(onSendMsg) forControlEvents:UIControlEventTouchUpInside];
        self.sendMsgBtn = button;
    }
    return self.sendMsgBtn;
}


#pragma mark - SetCell

- (void)setCell_SetRemark: (UITableViewCell *)cell{
    cell.textLabel.text = @"设置备注";
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    if (self.user.ext.length) {
        //分割线
        [cell createBottomLineWithHeight:1 left:0 right:0];
        [cell bottomLineLeftToTextlabel];
    }
}

- (void)setCell_Phone: (UITableViewCell *)cell{
    cell.textLabel.text = @"电话号码";
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell addSubview:[self getPhoneLbl]];
    
    [self.phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.mas_equalTo(cell);
        make.left.mas_equalTo(cell.textLabel.mas_left).with.offset(TableTextOffset);
    }];
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return JXUIRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100.f;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!self.isFriend){
        return 0;
    }
    else if(!self.user.ext.length){
        //没有备注手机
        return 1;
    }
    else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.item) {
        case 0:
            [self setCell_SetRemark:cell];
            break;
        case 1:
            [self setCell_Phone:cell];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == 0) {
        [self onSelectSetAliasCell];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    if (self.isFriend) {
        [footer addSubview:[self getSendMsgBtn]];
        [_sendMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(footer).with.offset(OffsetSize);
            make.height.mas_equalTo(BigButtonHeight);
            make.left.mas_equalTo(footer).with.offset(OffsetSize_Big);
            make.right.mas_equalTo(footer).with.offset(-OffsetSize_Big);
        }];
    }
    else{
        [footer addSubview:[self getAddFriendBtn]];
        [_addFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(footer).with.offset(OffsetSize);
            make.height.mas_equalTo(BigButtonHeight);
            make.left.mas_equalTo(footer).with.offset(OffsetSize_Big);
            make.right.mas_equalTo(footer).with.offset(-OffsetSize_Big);
        }];
    }
    
    return footer;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIView *headerView = nil;
    for(UIView *subView in scrollView.subviews){
        if ([subView isKindOfClass: [JXMinePortraitView class]]) {
            headerView = (JXMinePortraitView *)subView;
            break;
        }
    }
    if (headerView != nil) {
        CGFloat yOffset = scrollView.contentOffset.y;  // 偏移的y值
        CGFloat baseHeight = 0.f;
        if ([headerView isKindOfClass:[JXMinePortraitView class]]) {
            baseHeight = JXPortraitCellHeight;
        }
        if (yOffset + baseHeight < 0) {
            [headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(scrollView).with.offset(yOffset);
                make.width.and.centerX.mas_equalTo(scrollView);
                make.height.mas_equalTo(ABS(yOffset));
            }];
        }
    }
}

#pragma mark - RequestView

- (void)showAddFriendRequestView{
    //底板
    self.requestView = [UIView new];
    [self.requestView setBackgroundColor:[UIColor colorWithWhite:0.2f alpha: 0.5]];
    //对话框
    UIView *dialog = [UIView new];
    [dialog.layer setMasksToBounds:YES];
    [dialog.layer setCornerRadius:5.f];
    if (IOS_13) {
        [dialog setBackgroundColor:[UIColor systemBackgroundColor]];
    }
    else{
        [dialog setBackgroundColor:[UIColor whiteColor]];
    }
    //hint
    UILabel *hintLbl = [UILabel new];
    [hintLbl setText:@"请输入验证信息"];
    [hintLbl sizeToFit];
    //输入框
    self.requestMsgTxf = [UITextField new];
    [self.requestMsgTxf setBorderStyle:UITextBorderStyleRoundedRect];
    JIMAccount * selfData = JX_UserDataManager.userData;
    [self.requestMsgTxf setText:[NSString stringWithFormat:@"我是%@", selfData.jim_nickname]];
    //按钮
    UIButton *cancelBtn = [UIButton new];
    [cancelBtn setFrame:CGRectMake(0, 0, 50.f, 50.f)];
    [cancelBtn.layer setMasksToBounds:YES];
    [cancelBtn.layer setBorderWidth:0.5f];
    [cancelBtn.titleLabel setFont:[UIFont loginRegister_registerButton]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismissRequestView) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    UIButton *okBtn = [UIButton new];
    [okBtn setTag:1];
    [okBtn.layer setMasksToBounds:YES];
    [okBtn.layer setBorderWidth:0.5f];
    [okBtn.titleLabel setFont:[UIFont loginRegister_registerButton]];
    [okBtn setTitle:@"发送" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    [okBtn addTarget:self action:@selector(onAddFriend:) forControlEvents:UIControlEventTouchUpInside];
    if (IOS_13) {
        [cancelBtn setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
        [cancelBtn.layer setBorderColor:[UIColor systemGray5Color].CGColor];
        [okBtn.layer setBorderColor:[UIColor systemGray5Color].CGColor];
    }
    else{
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn.layer setBorderColor:[UIColor grayColor].CGColor];
        [okBtn.layer setBorderColor:[UIColor grayColor].CGColor];
    }
    
    [dialog addSubview:hintLbl];
    [dialog addSubview:self.requestMsgTxf];
    [dialog addSubview:cancelBtn];
    [dialog addSubview:okBtn];
    [self.requestView addSubview:dialog];
    [self.view addSubview:self.requestView];
    
    [self.requestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(0);
    }];
    [dialog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2 * OffsetSize_Big);
        make.right.mas_equalTo(-2 * OffsetSize_Big);
        make.height.mas_equalTo(150.f);
        make.centerY.mas_equalTo(self.requestView);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(BigButtonHeight);
        make.width.mas_equalTo(dialog.mas_width).multipliedBy(0.5f);
        make.bottom.and.left.mas_equalTo(dialog);
    }];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(BigButtonHeight);
        make.width.mas_equalTo(dialog.mas_width).multipliedBy(0.5f);
        make.bottom.and.right.mas_equalTo(dialog);
    }];
    [self.requestMsgTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(dialog).with.offset(OffsetSize_Big);
        make.right.mas_equalTo(dialog).with.offset(-OffsetSize_Big);
        make.height.mas_equalTo(25.f);
        make.bottom.mas_equalTo(okBtn.mas_top).with.offset(-OffsetSize_Big);
    }];
    [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(dialog);
        make.bottom.mas_equalTo(self.requestMsgTxf.mas_top).with.offset(-OffsetSize);
    }];
}

- (void)dismissRequestView{
    [self.requestView removeFromSuperview];
}


#pragma mark - 其他
- (void)setNavigationBarClear: (BOOL)isClear{
    if (@available(iOS 13.0, *)) {
        if (isClear) {
            UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
            [barAppearance configureWithTransparentBackground];
            [self.navigationController.navigationBar setStandardAppearance:barAppearance];
        }
        else{
            UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
            [barAppearance setBackgroundColor:[UIColor systemBackgroundColor]];
            [barAppearance setShadowColor:[UIColor systemBackgroundColor]];
            [self.navigationController.navigationBar setStandardAppearance:barAppearance];
        }
    }
}

- (void)refresh{
    [self loadData];
    [self.tableView reloadData];
    [self.portraitView refreshData: self.user];
}


@end
