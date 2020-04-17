//
//  JXMineWalletVC.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/9.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMineWalletVC.h"
#import "JXMineBalanceView.h"

@interface JXMineWalletVC()

@property(nonatomic, strong) JXMineBalanceView *headerView;

@end

@implementation JXMineWalletVC

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"钱包";
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.backgroundColor = [UIColor systemBlueColor];
}

- (void)loadData {
    NSArray *data = @[
        @{
            HeaderTitle  :@"",
            HeaderHeight :@SectionHeaderHeight,
            RowContent   :@[
                @{
                    Title         : @"账单明细",
                    CellAction    : @"onTouchCell:",
                    ShowAccessory : @(YES),
                    ShowBottomLine : @(YES),
                    ShowRedDot    : @(YES),
                },
                @{
                    Title         : @"红包明细",
                    CellAction    : @"onTouchCell:",
                    ShowAccessory : @(YES),
                },
            ],
        },
        @{
            HeaderTitle:@"",
            RowContent :@[
                @{
                    Title         :@"实名认证",
                    CellAction    :@"onTouchCell:",
                    ShowAccessory : @(YES)
                },
            ],
            FooterTitle:@""
        },
        @{
            HeaderTitle:@"",
            RowContent :@[
                @{
                    Title         :@"我的银行卡",
                    CellAction    :@"onTouchCell:",
                    ShowAccessory : @(YES)
                },
            ],
            FooterTitle:@""
        },
        @{
            HeaderTitle:@"",
            RowContent :@[
                @{
                    Title         :@"支付密码管理",
                    CellAction    :@"onTouchCell:",
                    ShowAccessory : @(YES)
                },
            ],
            FooterTitle:@""
        },
    ];
    self.data = [JXCommonTableSection sectionsWithData:data];
}


- (void)addHeaderView{
    //头视图
    NSDictionary *data = @{
        ExtraInfo     : [NSNull null],
        CellClass     : @"JXMineBalanceView",
        RowHeight     : @(JXWalletBalanceCellHeight),
        CellAction    : @"onTouchCell:",
        ShowAccessory : @(NO)
    };
    JXCommonTableRow *rowData = [[JXCommonTableRow alloc] initWithDict:data];
    self.headerView = [[JXMineBalanceView alloc] initWithFrame:CGRectZero];
    [self.headerView refreshData:rowData];
    [self.tableView addSubview:_headerView];
    //_tableView.tableHeaderView = _headerView;
    
    if (@available(iOS 11.0, *))    {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(JXWalletBalanceCellHeight, 0, 0, 0);
}


- (void)loadUI{
    [super loadUI];
    
    self.headerView.frame = CGRectMake(0,0,self.view.width, JXWalletBalanceCellHeight);
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(JXWalletBalanceCellHeight);
        make.width.and.centerX.mas_equalTo(self.tableView);
        make.top.mas_equalTo(self.tableView).with.offset(-JXWalletBalanceCellHeight);
    }];
}

#pragma mark - Action

- (void)onTouchCell:(id)sender{
    
}

@end
