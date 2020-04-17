//
//  MoreMenuView.m
//  jxim
//
//  Created by yangfantao on 2020/3/23.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "MoreMenuView.h"
#import "MoreMenuCell.h"
#import "UIColor+ColorExt.h"
#import "TLKit.h"


#define     WIDTH_TABLEVIEW             135.0f
#define     HEIGHT_TABLEVIEW_CELL       45.0f

@interface MoreMenuView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *addMenuItems;

@end

@implementation MoreMenuView

- (id)init
{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.tableView];
        
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:panGR];
        
        [self.tableView registerClass:[MoreMenuCell class] forCellReuseIdentifier:@"MoreMenuCell"];
        self.data = [self addMenuItems];
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [self setNeedsDisplay];
    [self setFrame:view.bounds];
    
    CGRect rect = CGRectMake(view.width - WIDTH_TABLEVIEW - 5, NAVBAR_HEIGHT + STATUSBAR_HEIGHT + 10, WIDTH_TABLEVIEW, self.data.count * HEIGHT_TABLEVIEW_CELL);
    [self.tableView setFrame:rect];
}

- (BOOL)isShow
{
    return self.superview != nil;
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            [self setAlpha:1.0];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

#pragma mark - # Delegate
//MARK: UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreMenuItem *item = [self.data objectAtIndex:indexPath.row];
    MoreMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreMenuCell"];
    [cell setItem:item];
    return cell;
}

//MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreMenuItem *item = [self.data objectAtIndex:indexPath.row];
    if (self.itemSelectedAction) {
        self.itemSelectedAction(self, item);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(addMenuView:didSelectedItem:)]) {
        [_delegate addMenuView:self didSelectedItem:item];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_TABLEVIEW_CELL;
}

#pragma mark - # Private Methods
- (void)drawRect:(CGRect)rect
{
    CGFloat startX = self.width - 27;
    CGFloat startY = STATUSBAR_HEIGHT + NAVBAR_HEIGHT + 3;
    CGFloat endY = STATUSBAR_HEIGHT + NAVBAR_HEIGHT + 10;
    CGFloat width = 6;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, startX + width, endY);
    CGContextAddLineToPoint(context, startX - width, endY);
    CGContextClosePath(context);
    [[UIColor colorBlackForMoreMenu] setFill];
    [[UIColor colorBlackForMoreMenu] setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - # Getters
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setScrollEnabled:NO];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor colorBlackForMoreMenu]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView.layer setMasksToBounds:YES];
        [_tableView.layer setCornerRadius:3.0f];
    }
    return _tableView;
}

- (NSArray *)addMenuItems
{
    if (!_addMenuItems) {
        return @[[self getMenuItemByType:MoreMneuTypeGroupChat],
                 [self getMenuItemByType:MoreMneuTypeAddFriend],
                 [self getMenuItemByType:MoreMneuTypeScan],
                 [self getMenuItemByType:MoreMneuTypeHelp],];
    }
    return _addMenuItems;
}

- (MoreMenuItem *)getMenuItemByType:(MoreMneuType)type
{
    switch (type) {
        case MoreMneuTypeGroupChat:// 群聊
            return [MoreMenuItem createWithType:MoreMneuTypeGroupChat
                                          title:@"发起群聊"
                                       iconPath:@"nav_menu_groupchat"
                                      className:@""];
            break;
        case MoreMneuTypeAddFriend:// 添加好友
            return [MoreMenuItem createWithType:MoreMneuTypeAddFriend
                                          title:@"添加好友"
                                       iconPath:@"nav_menu_addfriend"
                                      className:@"JXMoreContactsViewController"];
            break;
        case MoreMneuTypeScan:// 扫一扫
            return [MoreMenuItem createWithType:MoreMneuTypeScan
                                          title:@"扫一扫"
                                       iconPath:@"nav_menu_scan"
                                      className:@"JXScanningViewController"];
            break;
        case MoreMneuTypeHelp:// 帮助
            return [MoreMenuItem createWithType:MoreMneuTypeHelp
                                          title:@"帮助"
                                       iconPath:@"nav_menu_help"
                                      className:@"JXHelpViewController"];
            break;
        default:
            break;
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
