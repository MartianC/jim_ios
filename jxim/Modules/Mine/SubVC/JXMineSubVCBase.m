//
//  JXMineSubVCBase.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/9.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMineSubVCBase.h"

@implementation JXMineSubVCBase

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self loadUI];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //刷新数据
    [self loadData];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
}

- (void)loadData {
    
}

- (void)loadUI{
    
    __weak typeof(self) wself = self;
    self.delegator = [[JXCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    
    [self.view addSubview: [self getTableView]];
    [[self getTableView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.view.window.top);
    }];
}

-(UITableView *)getTableView
{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.tableView.delegate = self.delegator;
        self.tableView.dataSource = self.delegator;

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
        [self addHeaderView];
    }
    return self.tableView;
}

- (void)addHeaderView{
    
}

+ (BOOL)willShowRedDot{
    return false;
}

@end
