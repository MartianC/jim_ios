//
//  RecentSessionSRViewController.m
//  jxim
//
//  Created by yangfantao on 2020/4/10.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RecentSessionSRViewController.h"

@interface RecentSessionSRViewController ()

@end

@implementation RecentSessionSRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    
}
- (void)didDismissSearchController:(UISearchController *)searchController
{
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;//HeightForHeaderInSection(section);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    NSInteger groupNum = [JXContactManager.sharedInstance countOfGroup];
//    if (section == groupNum - 1) {
//        return 40.0f;
//    }
    return -1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    NSInteger groupNum = [JXContactManager.sharedInstance countOfGroup];
//    if (section == groupNum - 1) {
//        return _lblFriendCount;
//    }
    return nil;
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    //UITableViewIndex
//    for (UIView *view in [tableView subviews]) {
//        if ([view isKindOfClass:[NSClassFromString(@"UITableViewIndex") class]]) {
//           // 设置字体大小
//            [view setValue:[UIFont systemFontOfSize:14.0] forKey:@"_font"];
//           //设置view的大小
//            view.bounds = CGRectMake(0, 0, 20, 20);
//        }
//    }
//}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;//NIMContactDataRowHeight;
//    id<JXContactDataUniProtocol> contactData = [JXContactManager.sharedInstance contactDataUniProtocolOfIndexPath:indexPath];
//    if (!contactData) {
//        return 0 == indexPath.section ? ContactRowHeight_System : NIMContactDataRowHeight;
//    }
//    return contactData.jxContactMember.rowHeight;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return nil;
//    id<JXContactDataUniProtocol> contactData = [JXContactManager.sharedInstance contactDataUniProtocolOfIndexPath:indexPath];
//    if (!contactData)return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContaceItemCellReUseID];
//
//    NSString *reuseId = contactData.jxContactMember.reuseId;
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
//    if (!cell) {
//        Class cellCls = NSClassFromString(contactData.jxContactMember.cellClassName);
//        cell = [[cellCls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
//    }
//
//    if ([cell isKindOfClass:[JXSystemContactCell class]]) {
//        [(JXSystemContactCell *)cell refresh:contactData.systemContactDataProvider];
//    }
//    else
//    {
//        [(JXContactDataCell *)cell refreshUser:contactData.nimGroupMember];
//    }
//
//    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
//    NSInteger rowsNum = [JXContactManager.sharedInstance memberCountInGroup:section];
//    return rowsNum;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
//    return [JXContactManager.sharedInstance countOfGroup];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    return @"";
//    return [JXContactManager.sharedInstance titleOfGroup:section];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
