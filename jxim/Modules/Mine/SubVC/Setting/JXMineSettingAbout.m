//
//  JXMineSettingAbout.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/22.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMineSettingAbout.h"
#import <Masonry.h>

@interface JXMineSettingAbout ()

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel     *appNameLbl;
@property (nonatomic,strong) UILabel     *appVersionLbl;

@property (nonatomic,strong) NSDictionary *infoDic;

@end

@implementation JXMineSettingAbout

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoDic = [[NSBundle mainBundle] infoDictionary];
    [self loadUI];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"关于";
}

- (void)loadUI{
    [self.view addSubview: [self getTable]];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(self.view);
    }];
}



#pragma mark - 获取元素

- (UITableView *)getTable{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //段落背景
        //[self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        //段落标题颜色
        [self.tableView setSectionIndexColor:[UIColor text_greybg_darkgrey]];
        //去除tableView默认的分割线
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //禁止滑动
        [self.tableView setScrollEnabled:NO];

        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }

    return self.tableView;
}

- (UIImageView *) getIconImg{
    if (!self.iconImg) {
        self.iconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppIcon"]];
    }
    return self.iconImg;
}

- (UILabel *) getAppNameLbl{
    if (!self.appNameLbl) {
        self.appNameLbl = [UILabel new];
        [self.appNameLbl setText: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey]];
        NSLog(@"Name: %@", self.infoDic[@"CFBundleDisplayName"]);
        [self.appNameLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.f]];
        [self.appNameLbl sizeToFit];
    }
    return self.appNameLbl;
}

- (UILabel *) getAppVersionLbl{
    if (!self.appVersionLbl) {
        self.appVersionLbl = [UILabel new];
        [self.appVersionLbl setText: self.infoDic[@"CFBundleShortVersionString"]];
        [self.appVersionLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.f]];
        [self.appVersionLbl setTextColor:[UIColor grayColor]];
        [self.appVersionLbl sizeToFit];
    }
    return self.appVersionLbl;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return JXUIRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return JXSettingAboutHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001f;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, JXSettingAboutHeaderHeight)];
    //UIView *footer = [UIView new];
    [header addSubview:[self getIconImg]];
    [header addSubview:[self getAppNameLbl]];
    [header addSubview:[self getAppVersionLbl]];
    
    [self.appVersionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(header);
        make.bottom.mas_equalTo(header.mas_bottom).with.offset(-OffsetSize);
    }];
    [self.appNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(header);
        make.bottom.mas_equalTo(self.appVersionLbl.mas_top).with.offset(-OffsetSize_Small);
    }];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(100.f);
        make.centerX.mas_equalTo(header);
        make.bottom.mas_equalTo(self.appNameLbl.mas_top).with.offset(-OffsetSize);
    }];
    
    return header;
}



@end
