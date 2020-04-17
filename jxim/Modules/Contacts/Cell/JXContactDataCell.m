//
//  JXContactDataCell.m
//  jxim
//
//  Created by yangfantao on 2020/3/27.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXContactDataCell.h"
#import "UITableViewCell+CellExt.h"
#import "Masonry.h"
#import <NIMKit/NIMAvatarImageView.h>

@implementation JXContactDataCell

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

-(void)refreshUser:(id<NIMGroupMemberProtocol>)member
{
    [super refreshUser:member];
    
    [self bottomLineLeftToTextlabel];
    
    if (!member.avatarUrlString && member.avatarUrlString.length > 0) {
        NSURL *url = [[NSURL alloc] initWithString:member.avatarUrlString];
        [self.avatarImageView nim_setImageWithURL:url placeholderImage:member.avatarImage];
    }
}
@end
