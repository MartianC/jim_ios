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
#import "JIMAccountSimple.h"

@interface JXMinePortraitView()

//@property (nonatomic,strong) NIMAvatarImageView *avatar;

@property (nonatomic,strong) UIButton *avatar;
@property (nonatomic,strong) UIButton *avatarEditer;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *accountLabel;
@property (nonatomic,strong) UIImageView *gender;
@property (nonatomic,strong) UIImageView *background;
@property (nonatomic,strong) UIView *baseView;

@property (nonatomic,assign) BOOL isSelf;

@end

@implementation JXMinePortraitView


- (void)refreshData: (NIMUser *)userInfo{
    JIMAccountSimple *user = [JIMAccountSimple new];
    if (userInfo != nil) {
        if(userInfo.userInfo != nil && userInfo.userInfo.ext != nil){
            user.jim_account = userInfo.ext;
        }
        else{
            user.jim_account = @"";
        }
        user.jim_nickname = userInfo.alias.length ? userInfo.alias : userInfo.userInfo.nickName;
        user.jim_gender = userInfo.userInfo.gender;
        user.jim_header = userInfo.userInfo.avatarUrl;
    }
    else{
        self.isSelf = YES;
        JIMAccount *selfAccount = JX_UserDataManager.userData;
        user.jim_account = selfAccount.jim_account;
        user.jim_nickname = selfAccount.jim_nickname;
        user.jim_gender = selfAccount.jim_gender;
        user.jim_header = selfAccount.jim_header;
    }
    
    //留白
    self.baseView = [[UIView alloc] initWithFrame:CGRectZero];
    if (IOS_13) {
        [self.baseView setBackgroundColor: [UIColor systemBackgroundColor]];
    }
    else{
        [self.baseView setBackgroundColor: [UIColor whiteColor]];
    }
    [self addSubview: self.baseView];
    //背景图
    self.background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mine_portraitBG"]];
    [self.background setContentMode:UIViewContentModeScaleAspectFill];
    self.background.clipsToBounds = YES;
    [self addSubview: self.background];
    //昵称
    self.nameLabel      = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:NameFontSize];
    self.nameLabel.text = user.jim_nickname;
    [self.nameLabel sizeToFit];
    [self addSubview:self.nameLabel];
    //性别
    self.gender = [[UIImageView alloc] initWithFrame:CGRectZero];
    if (user.jim_gender == Gender_Male) {
        [self.gender setImage:[UIImage imageNamed:@"icon_mine_gender_male"]];
    }
    else if (user.jim_gender == Gender_Female){
        [self.gender setImage:[UIImage imageNamed:@"icon_mine_gender_female"]];
    }
    [self addSubview:self.gender];
    //账号
    self.accountLabel   = [[UILabel alloc] initWithFrame:CGRectZero];
    self.accountLabel.font = [UIFont systemFontOfSize:AccountFontSize];
    self.accountLabel.textColor = [UIColor grayColor];
    if (user.jim_account.length) {
        self.accountLabel.text = [NSString stringWithFormat:@"游聊号：%@", user.jim_account];
    }
    else{
        self.accountLabel.text = @"";
    }
    [self.accountLabel sizeToFit];
    [self addSubview:self.accountLabel];
    //头像
    self.avatar = [[UIButton alloc] initWithFrame:CGRectZero];
    [self addSubview:_avatar];
    [self.avatar setBackgroundImage:[UIImage imageNamed:@"icon_mine_defaultAvatar"] forState:UIControlStateNormal];
    [self.avatar setBackgroundImage:[UIImage imageNamed:@"icon_mine_defaultAvatar"] forState:UIControlStateHighlighted];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:[NSURL URLWithString:user.jim_header] options:nil context:nil progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image != nil) {
            [self.avatar setBackgroundImage:image forState:UIControlStateNormal];
            [self.avatar setBackgroundImage:image forState:UIControlStateHighlighted];
        }
    }];
    [self addSubview:self.avatar];
    
    if (self.isSelf) {
        [self.avatar addTarget:self action:@selector(onTouchAvatar) forControlEvents:UIControlEventTouchUpInside];
        self.avatarEditer = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.avatarEditer setBackgroundImage:[UIImage imageNamed:@"icon_mine_avaterEditer"] forState:UIControlStateNormal];
        [self.avatarEditer setBackgroundImage:[UIImage imageNamed:@"icon_mine_avaterEditer"] forState:UIControlStateHighlighted];
        [self.avatarEditer addTarget:self action:@selector(onTouchAvatar) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.avatarEditer];
    }

    [self loadUI];
}

- (void)loadUI{
    //圆角
    _avatar.layer.cornerRadius = AvatarSize / 2;//裁成圆角
    _avatar.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    //加边框
    _avatar.layer.borderWidth = AvatarBorderWidth;//边框宽度
    _avatar.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色
    
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
    [_gender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(_nameLabel.height / 2.f);
        make.centerY.mas_equalTo(_nameLabel);
        make.left.mas_equalTo(_nameLabel.mas_right).with.offset(OffsetSize_Small);
    }];
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(AvatarSize);
        make.bottom.mas_equalTo(_nameLabel.mas_top).with.offset(-OffsetSize);
    }];
    if (self.isSelf) {
        [_avatarEditer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_avatar.mas_bottom);
            make.size.mas_equalTo(AvatarEditerSize);
            make.centerX.mas_equalTo(_avatar.mas_centerX).with.offset(OffsetSize * 2);
        }];
    }
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
