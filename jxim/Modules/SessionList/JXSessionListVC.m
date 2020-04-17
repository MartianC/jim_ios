//
//  JXSessionListVC.m
//  jxim
//
//  Created by yangfantao on 2020/3/22.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXSessionListVC.h"
#import "MoreMenuView.h"
#import "UIColor+ColorExt.h"
#import "JXIMGlobalDef.h"
#import "TLKit.h"
#import "JXSessionSearchViewController.h"
#import "Masonry.h"
#import <NIMKit/NIMContactSelectConfig.h>
#import <NIMKit/NIMContactSelectViewController.h>
#import "SVProgressHUD.h"
#import "UIColor+ColorExt.h"
#import "UIFont+FontExt.h"
#import "RecentSessionSRViewController.h"
#import "SessionListHeader.h"
#import "JXBundleSetting.h"

@interface JXSessionListVC ()<NIMLoginManagerDelegate,NIMEventSubscribeManagerDelegate>

@property (nonatomic,strong) MoreMenuView *moreMenuView;
@property (nonatomic,strong) SessionListHeader *listHeader;
@property (nonatomic,strong) UIImageView *imgEmptyMsg;
@property (nonatomic,strong) UILabel *lblEmptyMsg;

@property(nonatomic,copy) NSString *titleText;

@end

@implementation JXSessionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.autoRemoveRemoteSession = [[JXBundleSetting sharedConfig] autoRemoveRemoteSession];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[NIMSDK sharedSDK].subscribeManager addDelegate:self];
    
    [self loadUI];
}

- (void)dealloc{
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
    [[NIMSDK sharedSDK].subscribeManager removeDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"消息";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
    if (self.moreMenuView.isShow) {
        [self.moreMenuView dismiss];
    }
}

-(void)loadUI
{
    //导航栏右边按钮定制
    UIBarButtonItem *search =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"moremenu_search"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(onSearchClick)];
    
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"moremenu_add"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(onMoreMenuClick)];
    
    self.navigationItem.rightBarButtonItems=@[more,search];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    //空消息提示
    [self.view addSubview:self.imgEmptyMsg];
    [self.view addSubview:self.lblEmptyMsg];
    [self.view addSubview:self.listHeader];
    
    self.imgEmptyMsg.hidden = self.recentSessions.count;
    self.lblEmptyMsg.hidden = self.recentSessions.count;
    
    [self.imgEmptyMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-100);
    }];
    
    [self.lblEmptyMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.imgEmptyMsg.mas_bottom);
    }];
    
    [self.listHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.listHeader.mas_bottom);
    }];
}

- (void)refresh{
    [super refresh];
    self.imgEmptyMsg.hidden = self.recentSessions.count;
    self.lblEmptyMsg.hidden = self.recentSessions.count;
}

-(void)listHeaderMsg:(NSString *)msg
{
    self.listHeader.msg = msg;
    if ([NSString isNulOrEmpty:msg]) {

        [self.listHeader mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.listHeader.mas_bottom);
        }];
    }
    else
    {
        [self.listHeader mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.listHeader.mas_bottom);
        }];
    }
}

-(void)onMoreMenuClick
{
    if (self.moreMenuView.isShow) {
        [self.moreMenuView dismiss];
    }
    else {
        [self.moreMenuView showInView:self.navigationController.view];
    }
}

-(void)onSearchClick
{
    JXSessionSearchViewController *searchVC = [[JXSessionSearchViewController alloc] init];
    searchVC.recentSessions = self.recentSessions;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (MoreMenuView *)moreMenuView
{
    if (!_moreMenuView) {
        _moreMenuView = [[MoreMenuView alloc] init];
        @weakify(self);
        [_moreMenuView setItemSelectedAction:^(MoreMenuView *addMenuView, MoreMenuItem *item) {
            @strongify(self);
            switch (item.type) {
                case MoreMneuTypeAddFriend:
                {
                    
                    break;
                }
                case MoreMneuTypeGroupChat:
                {
                    /*
                    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
                    [self presentMemberSelector:^(NSArray *uids) {
                        NSArray *members = [@[currentUserId] arrayByAddingObjectsFromArray:uids];
                        NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
                        option.name       = @"高级群";
                        option.type       = NIMTeamTypeAdvanced;
                        option.joinMode   = NIMTeamJoinModeNoAuth;
                        option.postscript = @"邀请你加入群组";
                        [SVProgressHUD show];
                        [[NIMSDK sharedSDK].teamManager createTeam:option users:members completion:^(NSError *error, NSString *teamId, NSArray<NSString *> * _Nullable failedUserIds) {
                            [SVProgressHUD dismiss];
                            if (!error) {
                                NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
                                NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
                                [wself.navigationController pushViewController:vc animated:YES];
                            }else{
                                [wself.view makeToast:@"创建失败".ntes_localized duration:2.0 position:CSToastPositionCenter];
                            }
                        }];
                    }];*/
                    break;
                }
                case MoreMneuTypeScan:
                {
                    break;
                }
                case MoreMneuTypeHelp :
                {
                    break;
                }
            }
        }];
    }
    return _moreMenuView;
}

- (void)presentMemberSelector:(ContactSelectFinishBlock) block{
    NSMutableArray *users = [[NSMutableArray alloc] init];
    //使用内置的好友选择器
    NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
    //获取自己id
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    [users addObject:currentUserId];
    //将自己的id过滤
    config.filterIds = users;
    //需要多选
    config.needMutiSelected = YES;
    //初始化联系人选择器
    NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
    //回调处理
    vc.finshBlock = block;
    [vc show];
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
        _lblEmptyMsg.text = @"暂无消息";
    }
    return _lblEmptyMsg;
}

-(SessionListHeader *)listHeader
{
    if (!_listHeader) {
        _listHeader = [[SessionListHeader alloc] init];
    }
    return _listHeader;
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
