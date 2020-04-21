//
//  JXAccountDetailSetAliasVC.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/20.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXAccountDetailSetAliasVC.h"
#import <NIMKit.h>
#import "Masonry.h"
#import "JXMineDef.h"
#import "UIColor+ColorExt.h"
#import <SVProgressHUD.h>
#import "UIFont+FontExt.h"
#import "UITableViewCell+CellExt.h"

@interface JXAccountDetailSetAliasVC ()

@property(nonatomic,copy) NSString *nimAccId;
@property (nonatomic,strong) NIMUser *user;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UITextField *aliasTxf;
@property (nonatomic,strong) UITextField *phoneTxf;
@property (nonatomic,strong) UITextField *descriptionTxf;

@end

@implementation JXAccountDetailSetAliasVC

-(instancetype)initWithNIMAccId:(NSString *)nimAccId
{
    if (self = [super init]) {
        _nimAccId = nimAccId;
        _user = [[NIMSDK sharedSDK].userManager userInfo:nimAccId];
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
    self.navigationItem.title = @"设置备注";
}

- (void)loadData{
    
}

- (void)loadUI{
    //导航栏定制
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onSetAliasDone)];
    
    [self.view addSubview:[self getTable]];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(0);
    }];
}


#pragma mark - Action

- (void)onSetAliasDone{
    self.user.alias = self.aliasTxf.text;
    self.user.ext = self.phoneTxf.text;
    [[[NIMSDK sharedSDK] userManager] updateUser:self.user completion:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


#pragma mark - 获取元素

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
    }

    return self.tableView;
}

- (UITextField *)getAliasTxf
{
    if (!_aliasTxf) {
        _aliasTxf = [[UITextField alloc] init];
        _aliasTxf.placeholder = @"输入用户备注";
        if(self.user.alias.length){
            _aliasTxf.text = self.user.alias;
        }
        _aliasTxf.clearButtonMode = UITextFieldViewModeWhileEditing;
        
    }
    return _aliasTxf;
}

- (UITextField *)getPhoneTxf
{
    if (!_phoneTxf) {
        _phoneTxf = [[UITextField alloc] init];
        _phoneTxf.placeholder = @"输入电话号码";
        if(self.user.ext.length){
            _phoneTxf.text = self.user.ext;
        }
        _phoneTxf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _phoneTxf;
}

- (UITextField *)getDescriptionTxf
{
    if (!_descriptionTxf) {
        _descriptionTxf = [[UITextField alloc] init];
        _descriptionTxf.placeholder = @"输入描述内容";
        _descriptionTxf.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _descriptionTxf;
}


#pragma mark - SetCell

- (void)setCell_Alias: (UITableViewCell *)cell{
    cell.textLabel.text = @"备注名";
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell addSubview:[self getAliasTxf]];
    //分隔线
    //[cell createBottomLineWithHeight:1 left:0 right:0];
    //[cell bottomLineLeftToTextlabel];
    
    [self.aliasTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.mas_equalTo(cell);
        make.left.mas_equalTo(cell.textLabel.mas_left).with.offset(TableTextOffset);
    }];
}

- (void)setCell_phone: (UITableViewCell *)cell{
    cell.textLabel.text = @"电话号码";
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell addSubview:[self getPhoneTxf]];
    //分隔线
    //[cell createBottomLineWithHeight:1 left:0 right:0];
    //[cell bottomLineLeftToTextlabel];
    
    [self.phoneTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.mas_equalTo(cell);
        make.left.mas_equalTo(cell.textLabel.mas_left).with.offset(TableTextOffset);
    }];
}

- (void)setCell_description: (UITableViewCell *)cell{
    cell.textLabel.text = @"描述";
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell addSubview:[self getDescriptionTxf]];
    
    [self.descriptionTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.right.mas_equalTo(cell);
        make.left.mas_equalTo(cell.textLabel.mas_left).with.offset(TableTextOffset);
    }];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return JXUIRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001f;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0:
            [self setCell_Alias:cell];
            break;
        case 1:
            [self setCell_phone:cell];
            break;
        case 2:
            [self setCell_description:cell];
            break;
        default:
            break;
    }
    
    return cell;
}


@end
