//
//  SessionListHeader.m
//  jxim
//
//  Created by yangfantao on 2020/4/10.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "SessionListHeader.h"
#import "Masonry.h"

@interface SessionListHeader()

@property(nonatomic,strong) UILabel *lblMsg;

@end

@implementation SessionListHeader

-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:207.0f/255.0f blue:207.0f/255.0f alpha:1.0f];
        [self addSubview:self.lblMsg];
        [self.lblMsg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(0);
        }];
    }
    return self;
}

-(UILabel *)lblMsg
{
    if(!_lblMsg)
    {
        _lblMsg = [[UILabel alloc] init];
        _lblMsg.textColor = [UIColor grayColor];
        _lblMsg.font = [UIFont systemFontOfSize:14.0f];
        _lblMsg.textAlignment = NSTextAlignmentCenter;
    }
    return _lblMsg;
}

-(NSString *)msg
{
    return self.lblMsg.text;
}

-(void)setMsg:(NSString *)msg
{
    self.lblMsg.text = msg;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
