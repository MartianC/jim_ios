//
//  UITableViewCell+CellExt.m
//  jxim
//
//  Created by yangfantao on 2020/3/26.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "UITableViewCell+CellExt.h"
#import "Masonry.h"
#import "JXIMGlobalDef.h"

#define BottomLineTag NSIntegerMax

@implementation UITableViewCell(UITableViewCell_CellExt)

-(void)createBottomLineWithHeight:(NSUInteger)height left:(NSUInteger)l right:(NSUInteger)r
{
    TableViewCellUILine_Block;
    UIView *line_1 = createLine();
    line_1.tag = BottomLineTag;
    [self addSubview:line_1];
    [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.left.mas_equalTo(l);
        make.right.mas_equalTo(r);
        make.bottom.mas_equalTo(0);
    }];
}

-(void)bottomLineLeftToTextlabel
{
    UIView *bottomLine = [self bottomLine];
    if (bottomLine) {
        [bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.height.mas_equalTo(1);
            make.left.mas_equalTo(self.textLabel.mas_left);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            
        }];
    }
}

-(nullable UIView *)bottomLine
{
    return [self viewWithTag:BottomLineTag];
}

@end
