//
//  JXMineBalanceView.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/9.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMineBalanceView.h"
#import "Masonry.h"
#import "UIFont+FontExt.h"
#import "UIColor+ColorExt.h"
#import <NIMKit.h>
#import "JXMineDef.h"

@interface JXMineBalanceView()

@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UILabel *lbl_hint;
@property (nonatomic,strong) UILabel *lbl_balance;
@property (nonatomic,strong) UIButton *btn_cashIn;
@property (nonatomic,strong) UIButton *btn_cashOut;

@end

@implementation JXMineBalanceView

- (void)refreshData:(JXCommonTableRow *)rowData{
    //背景
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.backgroundView setBackgroundColor:UIColor.systemBlueColor];
    [self addSubview:self.backgroundView];
    //余额
    self.lbl_hint = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.lbl_hint setText:@"账户余额(元)"];
    [self.lbl_hint setFont:[UIFont systemFontOfSize:AccountFontSize]];
    //[self.lbl_hint sizeToFit];
    NSString *balance = rowData.extraInfo;
    if (![balance isKindOfClass:[NSString class]]) {
        balance = @"0.00";
    }
    self.lbl_balance = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.lbl_balance setText:balance];
    [self.lbl_balance setFont:[UIFont fontWithName:@"Helvetica-Bold" size:NameFontSize]];
    //[self.lbl_balance sizeToFit];
    [self addSubview:self.lbl_balance];
    [self addSubview:self.lbl_hint];
    //充值、提现
    self.btn_cashIn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.btn_cashIn setTitle:@"充值" forState:UIControlStateNormal];
    [self.btn_cashIn setBackgroundColor:[UIColor systemBackgroundColor]];
    [self.btn_cashIn setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    self.btn_cashOut = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.btn_cashOut setTitle:@"提现" forState:UIControlStateNormal];
    [self.btn_cashOut setBackgroundColor:[UIColor systemBackgroundColor]];
    [self.btn_cashOut setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    [self addSubview:self.btn_cashIn];
    [self addSubview:self.btn_cashOut];
    
    [self loadUI];
}

- (void)loadUI{
    [self.btn_cashIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(BalanceButtonHeight);
        make.width.mas_equalTo(self.bounds.size.width / 2.f);
        make.left.and.bottom.mas_equalTo(self);
    }];
    [self.btn_cashOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(BalanceButtonHeight);
        make.width.mas_equalTo(self.bounds.size.width / 2.f);
        make.right.and.bottom.mas_equalTo(self);
    }];
    [self.lbl_balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.btn_cashIn).with.offset(-2 * OffsetSize);
    }];
    [self.lbl_hint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.lbl_balance).with.offset(-OffsetSize);
    }];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.and.centerY.mas_equalTo(self);
    }];
}

@end
