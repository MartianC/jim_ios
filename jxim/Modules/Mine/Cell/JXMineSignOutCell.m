//
//  JXMineSignOutCell.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/3.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMineSignOutCell.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "UIFont+FontExt.h"
#import "UIColor+ColorExt.h"
#import <NIMKit.h>
#import "NIMAvatarImageView.h"

@interface JXMineSignOutCell()

@property (nonatomic,strong) UIButton *btn_signOut;

@end

@implementation JXMineSignOutCell

- (void)refreshData:(JXCommonTableRow *)rowData tableView:(UITableView *)tableView{
    self.btn_signOut = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.btn_signOut setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.btn_signOut setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    [self.btn_signOut addTarget:self action:@selector(signOut) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn_signOut];
    [self loadUI];
}

- (void)loadUI{
    [self.btn_signOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.mas_equalTo(0);
    }];
    [self.btn_signOut.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(self.btn_signOut);
    }];
}

- (void)signOut{
    
}

@end
