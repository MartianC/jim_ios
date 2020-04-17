//
//  JXSearchContactManager.m
//  jxim
//
//  Created by yangfantao on 2020/3/30.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXSearchContactManager.h"
#import <NIMKit/NIMKit.h>
#import "JXContactGroupData.h"
#import "TLKit.h"

@interface JXSearchContactManager()

@property(nonatomic,copy) NSMutableArray<JXContactGroupData *> *groupData;

@end

@implementation JXSearchContactManager

JXSingleton_Impl(JXSearchContactManager)

- (void)readyDataOfSearchContent:(NSString *)searchContent
{
    if (!searchContent || searchContent.length < 1) return;
    if (!_groupData) {
        _groupData = [[NSMutableArray<JXContactGroupData *> alloc] init];
    }
    [_groupData removeAllObjects];
    
    @weakify(self);
    //搜好友
    NIMUserSearchOption *userSearchOption = [[NIMUserSearchOption alloc] init];
    userSearchOption.searchRange = NIMUserSearchRangeOptionFriends;
    userSearchOption.searchContentOption = NIMUserSearchContentOptionAlias | NIMUserSearchContentOptionNickName;
    userSearchOption.ignoreingCase = YES;
    userSearchOption.searchContent = searchContent;
    [NIMSDK.sharedSDK.userManager searchUserWithOption:userSearchOption completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
       
        if (!users && users.count > 0) {
            
        }
        
    }];
    
    //搜索群聊
    
}

- (NSInteger)memberCountInGroup:(NSInteger)groupIdx
{
    if (!_groupData || groupIdx >= _groupData.count) {
        return 0;
    }
    return [[_groupData objectAtIndex:groupIdx] memberNum];
}

- (NSInteger)countOfGroup
{
    if (!_groupData) {
        return 0;
    }
    return _groupData.count;
}

- (NSString *)titleOfGroup:(NSInteger)groupIdx
{
    if (!_groupData || groupIdx >= _groupData.count) {
        return @"";
    }
    return [[_groupData objectAtIndex:groupIdx] title];
}

- (id<JXContactDataUniProtocol>)contactDataUniProtocolOfIndexPath:(NSIndexPath *)indexPath
{
    if (!_groupData || indexPath.section >= _groupData.count) return nil;
    
    JXContactGroupData *groupData = [_groupData objectAtIndex:indexPath.section];
    if (!groupData) return nil;
    
    JXContactMemberData *memberData = [groupData memberAtIndex:indexPath.row];
    if(!memberData)return nil;
    
    return memberData.contactDataUniProtocol;
}

@end
