//
//  MoreMenuCell.m
//  jxim
//
//  Created by yangfantao on 2020/3/23.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "MoreMenuCell.h"
#import "ZZFLEX.h"
#import "Masonry.h"
#import "JXIMGlobalDef.h"
#import "UIColor+ColorExt.h"

@interface MoreMenuCell()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MoreMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor colorBlackForMoreMenu]];
        UIView *selectedView = [[UIView alloc] init];
        [selectedView setBackgroundColor:[UIColor colorBlackForMoreMenuHL]];
        [self setSelectedBackgroundView:selectedView];
    
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.addSeparator(ZZSeparatorPositionBottom).beginAt(15).endAt(-15).color([UIColor colorGrayLine]);
}

- (void)setItem:(MoreMenuItem *)item
{
    _item = item;
    [self.iconView setImage:[UIImage imageNamed:item.iconPath]];
    [self.titleLabel setText:item.title];
}

#pragma mark - Private Methods
- (void)initUI
{
    self.iconView = self.contentView.addImageView(1)
    .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(20.0f);
        make.centerY.mas_equalTo(self);
        //make.height.and.width.mas_equalTo(32);
    })
    .view;
    
    self.titleLabel = self.contentView.addLabel(2)
    .font([UIFont systemFontOfSize:14.0f])
    .textColor([UIColor whiteColor])
    .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(20.0f);
        make.centerY.mas_equalTo(self.iconView);
    })
    .view;
}

@end
