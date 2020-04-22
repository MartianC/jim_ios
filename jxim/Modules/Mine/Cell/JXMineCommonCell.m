//
//  JXMineCommonCell.m
//  jxim
//
//  Created by Xueyue Liu on 2020/3/31.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMineCommonCell.h"
#import "JXCommonTableData.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "UITableViewCell+CellExt.h"
#import "UIView+ViewExt.h"
#import "JXMineDef.h"

@interface JXMineCommonCell()

@property (nonatomic,strong) UIImageView *redDot;
@property BOOL bottomLine;

@end

@implementation JXMineCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)refreshData:(JXCommonTableRow *)rowData tableView:(UITableView *)tableView{
    [self.imageView setImage:[UIImage imageNamed:rowData.icon]];
    self.textLabel.text = rowData.title;
    self.detailTextLabel.text = rowData.detailTitle;
    //右侧箭头样式
    if (!rowData.showAccessory) {
        //self.accessoryType = UITableViewCellAccessoryNone;
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
    else{
        UISwitch *switchView = [UISwitch new];
        switch (rowData.accessoryType) {
            case AccessoryType_Switch:
            {//开关样式
                [self setSelectionStyle:UITableViewCellSelectionStyleNone];
                [switchView setOn:[rowData.extraInfo boolValue] animated:NO];
                [switchView removeTarget:self.viewController action:NULL forControlEvents:UIControlEventValueChanged];
                NSString *actionName = rowData.cellActionName;
                if (actionName.length) {
                    SEL sel = NSSelectorFromString(actionName);
                    [switchView addTarget:tableView.viewController action:sel forControlEvents:UIControlEventValueChanged];
                    
                }
                [self setAccessoryView:switchView];
                break;
            }
            default:
                //默认箭头样式
                [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
        }
    }
    //self.accessoryType = rowData.showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    //分隔线
    if (rowData.showBottomLine && !self.bottomLine) {
        [self createBottomLineWithHeight:1 left:0 right:0];
        [self bottomLineLeftToTextlabel];
        self.bottomLine = YES;
    }
    
    if (rowData.showRedDot) {
        self.redDot = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.redDot.backgroundColor = [UIColor redColor];
        [self addSubview: self.redDot];
        [self loadUI];
    }
}

- (void)loadUI{
    
    //圆角
    self.redDot.layer.cornerRadius = 4.f;//裁成圆角
    self.redDot.layer.masksToBounds = YES;//隐藏裁剪掉的部分
    [self.redDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(8.f);
        make.centerY.mas_equalTo(self);
        if (self.detailTextLabel.text.length) {
            make.left.mas_equalTo(self.detailTextLabel.mas_right);
        }
        else {
            self.detailTextLabel.text = @" ";
            make.right.mas_equalTo(self.detailTextLabel.mas_right);
        }
    }];
}

@end
