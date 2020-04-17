//
//  JXSystemContactCell.m
//  jxim
//
//  Created by yangfantao on 2020/3/27.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXSystemContactCell.h"
#import "UITableViewCell+CellExt.h"
#import "NIMAvatarImageView.h"
#import "JXBadgeView.h"
#import "Masonry.h"
#import "UIColor+ColorExt.h"

@interface JXSystemContactCell()

@property(nonatomic,strong) UIImageView *imgIdentity;
@property(nonatomic,strong) JXBadgeView *badge;

@end

@implementation JXSystemContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createBottomLineWithHeight:1 left:0 right:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refresh:(id<JXSystemContactDataProviderProtocol>)data
{
    self.imageView.image = data.avatarImage;
    self.textLabel.text = data.showName;
    [self.textLabel sizeToFit];
    
    [self bottomLineLeftToTextlabel];
    
    NSString *identity = data.identity;
    if (identity.length > 0) {
        
        self.imgIdentity.hidden = NO;
        self.imgIdentity.image = [UIImage imageNamed:identity];
        self.textLabel.textColor = [UIColor text_whitebg_blue_light];
        
        [self.imgIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textLabel).mas_equalTo(self.textLabel.bounds.size.width + 10);
            make.centerY.mas_equalTo(self.textLabel);
        }];
        
    }
    else{
        if (nil != _imgIdentity) {
            _imgIdentity.hidden = YES;
        }
    }

    NSString *badgeValue = data.badgeValue;
    if (badgeValue.length > 0) {
        
        self.badge.hidden = NO;
        self.badge.badgeValue = badgeValue;
        CGSize size = self.badge.bounds.size;
        [self.badge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(size.width);
            make.height.mas_equalTo(size.height);
        }];
    }
    else{
        if (nil != _badge) {
            _badge.hidden = YES;
        }
    }
}

-(UIImageView *)imgIdentity
{
    if (!_imgIdentity) {
        _imgIdentity = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgIdentity];
    }
    return _imgIdentity;
}

-(JXBadgeView *)badge
{
    if (!_badge) {
        _badge = [JXBadgeView viewWithBadgeTip:@""];
        [self.contentView addSubview:_badge];
    }
    return _badge;
}

@end
