//
//  JXMinePortraitCell.m
//  jxim
//
//  Created by Xueyue Liu on 2020/4/1.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMinePortraitCell.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "UIFont+FontExt.h"
#import "UIColor+ColorExt.h"
#import <NIMKit.h>
#import "NIMAvatarImageView.h"
#import "JXMinePortraitVC.h"
#import "JXMineDef.h"

@interface JXMinePortraitCell()

@property (nonatomic,strong) UIImageView *avatar;

@end

@implementation JXMinePortraitCell

- (void)refreshData:(JXCommonTableRow *)rowData tableView:(UITableView *)tableView{
    [super refreshData:rowData tableView:tableView];

    self.avatar = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview: self.avatar];
    NSString *userHeader = rowData.extraInfo;
    if ([userHeader isKindOfClass:[NSString class]] && userHeader.length) {
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:userHeader] placeholderImage:[UIImage imageNamed:@"icon_mine_defaultAvatar"]];
    }
    else{
        [self.avatar setImage:[UIImage imageNamed:@"icon_mine_defaultAvatar"]];
    }
    
    [self loadUI];
}

- (void)loadUI{
    //圆角
    _avatar.layer.cornerRadius = SettingAvatarSize / 2;//裁成圆角
    _avatar.layer.masksToBounds = YES;//隐藏裁剪掉的部分

    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(SettingAvatarSize);
        //占位
        self.detailTextLabel.text = @" ";
        make.right.mas_equalTo(self.detailTextLabel.mas_right);
    }];
}


@end
