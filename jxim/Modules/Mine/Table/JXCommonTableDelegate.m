//
//  JXCommonTableDelegate.m
//  jxim
//
//  Created by Xueyue Liu on 2020/3/31.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXCommonTableDelegate.h"
#import "JXCommonTableData.h"
#import "JXMineCommonCell.h"
#import "JXMinePortraitCell.h"
#import "JXMineSignOutCell.h"
#import "UIView+NIM.h"
#import "NIMGlobalMacro.h"
#import "JXMinePortraitView.h"
#import "JXMineBalanceView.h"
#import "JXMineDef.h"
#import "Masonry.h"

static NSString *DefaultTableCell = @"JXMineCommonCell";

@interface JXCommonTableDelegate()

@property (nonatomic,copy) NSArray *(^JXDataReceiver)(void);

@end

@implementation JXCommonTableDelegate

- (instancetype) initWithTableData:(NSArray *(^)(void))data{
    self = [super init];
    if (self) {
        _JXDataReceiver = data;
    }
    return self;
}

- (NSArray *)data{
    return self.JXDataReceiver();
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JXCommonTableSection *tableSection = self.data[section];
    return tableSection.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXCommonTableSection *tableSection = self.data[indexPath.section];
    JXCommonTableRow     *tableRow     = tableSection.rows[indexPath.row];
    NSString *identity = tableRow.cellClassName.length ? tableRow.cellClassName : DefaultTableCell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        Class clazz = NSClassFromString(identity);
        cell = [[clazz alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
        UIView *sep = [[UIView alloc] initWithFrame:CGRectZero];
        
        sep.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        sep.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:sep];
    }
    
    if ([cell isKindOfClass:[JXMinePortraitCell class]]){
        [(JXMinePortraitCell *)cell refreshData: tableRow tableView:tableView];
    }
    else if ([cell isKindOfClass:[JXMineSignOutCell class]]){
        [(JXMineSignOutCell *)cell refreshData: tableRow tableView:tableView];
    }
    else{
        [(JXMineCommonCell *)cell refreshData: tableRow tableView:tableView];
    }
    
    //cell.accessoryType = tableRow.showAccessory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = !tableRow.userInteractionDisable;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    JXCommonTableSection *tableSection = self.data[section];
    return tableSection.footerTitle;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JXCommonTableSection *tableSection = self.data[indexPath.section];
    JXCommonTableRow     *tableRow     = tableSection.rows[indexPath.row];
    return tableRow.uiRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    JXCommonTableSection *tableSection = self.data[section];
    return tableSection.uiHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    JXCommonTableSection *tableSection = self.data[section];
    return tableSection.uiFooterHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    JXCommonTableSection *tableSection = self.data[indexPath.section];
    JXCommonTableRow     *tableRow     = tableSection.rows[indexPath.row];
    if (!tableRow.forbidSelect) {
        UIViewController *vc = tableView.nim_viewController;
        NSString *actionName = tableRow.cellActionName;
        if (actionName.length) {
            SEL sel = NSSelectorFromString(actionName);
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NIMKit_SuppressPerformSelectorLeakWarning([vc performSelector:sel withObject:cell]);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIView *headerView = nil;
    for(UIView *subView in scrollView.subviews){
        if ([subView isKindOfClass: [JXMinePortraitView class]]) {
            headerView = (JXMinePortraitView *)subView;
            break;
        }
        else if ([subView isKindOfClass: [JXMineBalanceView class]]) {
            headerView = (JXMineBalanceView *)subView;
            break;
        }
    }
    if (headerView != nil) {
        CGFloat yOffset = scrollView.contentOffset.y;  // 偏移的y值
        CGFloat baseHeight = 0.f;
        if ([headerView isKindOfClass:[JXMinePortraitView class]]) {
            baseHeight = JXPortraitCellHeight;
        }
        else if ([headerView isKindOfClass:[JXMineBalanceView class]]){
            baseHeight = JXWalletBalanceCellHeight;
        }
        if (yOffset + baseHeight < 0) {
            [headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(scrollView).with.offset(yOffset);
                make.width.and.centerX.mas_equalTo(scrollView);
                make.height.mas_equalTo(ABS(yOffset));
            }];
        }
    }
}


@end
