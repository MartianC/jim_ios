//
//  JXMinePortraitView.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/7.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMinePortraitView.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "UIFont+FontExt.h"
#import "UIColor+ColorExt.h"
#import <NIMKit.h>
#import "NIMAvatarImageView.h"
#import "JXMinePortraitVC.h"
#import "JXMineDef.h"
#import "JXUserDataManager.h"

@interface JXMinePortraitView()

@property (nonatomic,strong) NIMAvatarImageView *avatar;

@property (nonatomic,strong) UIButton *avatar_test;
@property (nonatomic,strong) UIButton *avatarEditer;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *accountLabel;

@property (nonatomic,strong) UIImageView *background;

@property (nonatomic,strong) UIView *baseView;

@end

@implementation JXMinePortraitView


- (void)refreshData{
    //留白
    self.baseView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.baseView setBackgroundColor: [UIColor systemBackgroundColor]];
    [self addSubview: self.baseView];
    //背景图
    self.background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mine_portraitBG"]];
    [self.background setContentMode:UIViewContentModeScaleAspectFill];
    self.background.clipsToBounds = YES;
    [self addSubview: self.background];
    //头像
    self.avatar_test = [[UIButton alloc] initWithFrame:CGRectZero];
    [self addSubview:_avatar_test];
    //昵称
    self.nameLabel      = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:NameFontSize];
    [self addSubview:self.nameLabel];
    //账号
    self.accountLabel   = [[UILabel alloc] initWithFrame:CGRectZero];
    self.accountLabel.font = [UIFont systemFontOfSize:AccountFontSize];
    self.accountLabel.textColor = [UIColor grayColor];
    [self addSubview:self.accountLabel];

    
    [self.avatar_test setBackgroundImage:[UIImage imageNamed:@"icon_mine_defaultAvatar"] forState:UIControlStateNormal];
    [self.avatar_test setBackgroundImage:[UIImage imageNamed:@"icon_mine_defaultAvatar"] forState:UIControlStateHighlighted];
    JIMAccount *user = JXUserDataManager.sharedInstance.userData;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:[NSURL URLWithString:user.jim_header] options:nil context:nil progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image != nil) {
            [self.avatar_test setBackgroundImage:image forState:UIControlStateNormal];
            [self.avatar_test setBackgroundImage:image forState:UIControlStateHighlighted];
        }
    }];
    
    self.nameLabel.text = user.jim_nickname;
    [self.nameLabel sizeToFit];
    self.accountLabel.text = user.jim_account;
    [self.accountLabel sizeToFit];
    
    [self.avatar_test addTarget:self action:@selector(onTouchAvatar) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.avatar_test];
    self.avatarEditer = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.avatarEditer setBackgroundImage:[UIImage imageNamed:@"icon_mine_avaterEditer"] forState:UIControlStateNormal];
    [self.avatarEditer setBackgroundImage:[UIImage imageNamed:@"icon_mine_avaterEditer"] forState:UIControlStateHighlighted];
    [self.avatarEditer addTarget:self action:@selector(onTouchAvatar) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.avatarEditer];

    [self loadUI];
}

- (void)loadUI{
    //圆角
    _avatar_test.layer.cornerRadius = AvatarSize / 2;//裁成圆角
    _avatar_test.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    //加边框
    _avatar_test.layer.borderWidth = AvatarBorderWidth;//边框宽度
    _avatar_test.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色
    
    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(BaseViewHeight);
        make.width.and.centerX.and.bottom.mas_equalTo(self);
    }];
    [_background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(_baseView.mas_top);
        make.top.mas_equalTo(self);
    }];
    [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).with.offset(-OffsetSize);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(_accountLabel.mas_top).with.offset(-OffsetSize);
    }];
    [_avatar_test mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(AvatarSize);
        make.bottom.mas_equalTo(_nameLabel.mas_top).with.offset(-OffsetSize);
    }];
    [_avatarEditer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_avatar_test.mas_bottom);
        make.size.mas_equalTo(AvatarEditerSize);
        make.centerX.mas_equalTo(_avatar_test.mas_centerX).with.offset(OffsetSize * 2);
    }];
}


- (void)onTouchAvatar{
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    UIViewController *superController = (UIViewController*)object;
    JXMinePortraitVC *vc = [[JXMinePortraitVC alloc] initWithNibName:nil bundle:nil];
    [superController.navigationController pushViewController:vc animated:YES];
}


@end
