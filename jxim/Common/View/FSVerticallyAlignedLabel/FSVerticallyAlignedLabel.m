//
//  FSVerticallyAlignedLabel.m
//  jxim
//
//  Created by yangfantao on 2020/3/29.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "FSVerticallyAlignedLabel.h"

@implementation FSVerticallyAlignedLabel

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}
 
/**
 *  设置属性方法
 *
 *  @param verticalAlignment 垂直调整位置
 */
- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment
{
    _verticalAlignment = verticalAlignment;
     
    [self setNeedsDisplay];
}
 
/**
 *  计算文字的矩形区域
 *
 *  @param bounds        label矩形区域
 *  @param numberOfLines 行数
 *
 *  @return 返回文字所占的矩形区域
 */
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
     
    //通过设定字体区域的y值来调整垂直位置
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentMiddle:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
    }
     
    return textRect;
}
 
//重写父类方法
- (void)drawTextInRect:(CGRect)rect
{
    CGRect actualRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
