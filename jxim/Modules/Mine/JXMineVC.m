//
//  JXMineVC.m
//  jxim
//
//  Created by yangfantao on 2020/3/22.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMineVC.h"
#import "JXCommonTableData.h"
#import "JXCommonTableDelegate.h"
#import "UIColor+ColorExt.h"
#import "TLKit.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "UIFont+FontExt.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMSDK/NIMUserManagerProtocol.h>
#import "JXMineSettingVC.h"
#import "JXMineDef.h"
#import "JXMinePortraitView.h"
#import "JXMineWalletVC.h"
#import "JXUserDataManager.h"

@interface JXMineVC ()<NIMUserManagerDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) JXMinePortraitView *headerView;
@property (nonatomic,strong) NSArray *data;
//@property (nonatomic,strong) NTESLogUploader *logUploader;
@property (nonatomic,strong) JXCommonTableDelegate *delegator;

@end

@implementation JXMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self loadUI];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"";
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //刷新视图
    [self refresh];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)loadData {
    NSArray *data = @[
//        @{
//            HeaderTitle:@"aaa",
//            RowContent :@[
//                @{
//                    ExtraInfo     : uid.length ? uid : [NSNull null],
//                    CellClass     : @"JXMinePortraitCell",
//                    RowHeight     : @(JXPortraitCellHeight),
//                    CellAction    : @"onTouchPortrait:",
//                    ShowAccessory : @(NO)
//                },
//            ],
//            FooterTitle:@"bbb"
//        },
        @{
            HeaderTitle:@"",
            HeaderHeight :@SectionHeaderHeight,
            RowContent :@[
                @{
                    Title         : @"扫一扫",
                    Icon          : @"icon_mine_scanner",
                    CellAction    : @"onTouchScanner:",
                    ShowAccessory : @(YES),
                },
            ],
        },
        @{
            HeaderTitle:@"",
            RowContent :@[
                @{
                    Title         : @"我的钱包",
                    Icon          : @"icon_mine_wallet",
                    CellAction    : @"onTouchMyWallet:",
                    ShowAccessory : @(YES),
                },
            ],
        },
        @{
            HeaderTitle:@"",
            RowContent :@[
                @{
                    Title         :@"相册",
                    Icon          : @"icon_mine_photo",
                    CellAction    :@"onTouchMyPhoto:",
                    ShowAccessory : @(YES)
                },
            ],
            FooterTitle:@""
        },
        @{
            HeaderTitle:@"",
            RowContent :@[
                @{
                    Title         :@"收藏",
                    Icon          : @"icon_mine_favorite",
                    CellAction    :@"onTouchMyFavorite:",
                    ShowAccessory : @(YES)
                },
            ],
            FooterTitle:@""
        },
        @{
            HeaderTitle:@"",
            RowContent :@[
                @{
                    Title         :@"帮助",
                    Icon          : @"icon_mine_helper",
                    CellAction    :@"onTouchHelp:",
                    ShowAccessory : @(YES),
                    ShowBottomLine : @(YES),
                },
                @{
                    Title         : @"设置",
                    Icon          : @"icon_mine_setting",
                    CellAction    : @"onTouchSetting:",
                    ShowAccessory : @(YES),
                    ShowRedDot    : @([JXMineSettingVC willShowRedDot]),
                },
            ],
        },
    ];
    self.data = [JXCommonTableSection sectionsWithData:data];
}

- (void)loadUI{

    __weak typeof(self) wself = self;
    self.delegator = [[JXCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(0);
        //make.top.mas_equalTo(-STATUS_BAR_SIZE.height);
    }];
    
    self.headerView.frame = CGRectMake(0,0,self.view.width, JXPortraitCellHeight);
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(JXPortraitCellHeight);
        make.width.and.centerX.mas_equalTo(self.tableView);
        make.top.mas_equalTo(self.tableView).with.offset(-JXPortraitCellHeight);
    }];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        //_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self.delegator;
        _tableView.dataSource = self.delegator;

        //self.tableView.backgroundColor = [UIColor background_lightgrey];
        //段落背景
        [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        //段落标题颜色
        [self.tableView setSectionIndexColor:[UIColor text_greybg_darkgrey]];
        //去除tableView默认的分割线
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
        //头视图
//        JIMAccount *user = JXUserDataManager.sharedInstance.userData;
//        NSDictionary *data = @{
//            ExtraInfo     : uid.length ? uid : [NSNull null],
//        };
//        JXCommonTableRow *rowData = [[JXCommonTableRow alloc] initWithDict:data];
        _headerView = [[JXMinePortraitView alloc] initWithFrame:CGRectZero];
        [_headerView refreshData];
        [_tableView addSubview:_headerView];
        //_tableView.tableHeaderView = _headerView;
        
        if (@available(iOS 11.0, *))    {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        _tableView.contentInset = UIEdgeInsetsMake(JXPortraitCellHeight, 0, 0, 0);
    }
    return _tableView;
}

- (void)refresh{
    if (_headerView != nil) {
        [_headerView refreshData];
    }
    [self loadData];
    [self.tableView reloadData];
}


#pragma mark - Action

- (void)onTouchPortrait:(id)sender{
    
}

- (void)onTouchScanner:(id)sender{
    
}

- (void)onTouchMyWallet:(id)sender{
    JXMineWalletVC *vc = [[JXMineWalletVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchMyPhoto:(id)sender{
    
}

- (void)onTouchMyFavorite:(id)sender{
    
}

- (void)onTouchHelp:(id)sender{
    
}

//设置
- (void)onTouchSetting:(id)sender{
    JXMineSettingVC *vc = [[JXMineSettingVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
