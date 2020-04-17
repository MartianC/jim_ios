//
//  JXContactManager.m
//  jxim
//
//  Created by yangfantao on 2020/3/26.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXContactManager.h"
#import <NIMKit/NIMKit.h>


@interface JXContactManager()

@property(nonatomic,copy) NSMutableArray<JXContactGroupData *> *groupData;
@property(nonatomic,copy) NSMutableDictionary<NSString *,NSNumber *> *titleIndex;
@property(nonatomic,assign) NSInteger nimUserCount;

@end

@implementation JXContactManager

JXSingleton_Impl(JXContactManager)

-(NIMKitInfo *)testData:(NSInteger)idx
{
    NIMKitInfo *info = [[NIMKitInfo alloc] init];
    info.avatarImage = nil;
    info.infoId = [NSString stringWithFormat:@"infoid_000000%ld",(long)idx];
    /*
    @property (nonatomic,copy) NSString *infoId;
    @property (nonatomic,copy)   NSString *showName;
    @property (nonatomic,copy)   NSString *avatarUrlString;
    @property (nonatomic,strong) UIImage  *avatarImage;
    */
    /*
     @_@
     铝合金工艺！14708777503
     梦开始的地方
     微测5
     茜茜
     禄丰小茶馆客服
     天天忙不完
     只因为你
     小气
     onlyヽMe灬
     */
    switch (idx) {
        case 0:
        {
            info.showName = @"@_@";
            info.avatarUrlString = @"http://wx.qlogo.cn/mmopen/vi_32/jamibYZqelrichg0Ip9Z1rxicpibRO3OYT3ibIZIIovmUibxXJjHUW8micJicJpwMwEdSBHldLSZJicUIuoxy1kk6siaLlDg/0";
            break;
        }
        case 1:
        {
            info.showName = @"铝合金工艺！14708777503";
            info.avatarUrlString = @"http://wx.qlogo.cn/mmopen/vi_32/x9U78tCoyfgK6cptSLeUAZ4BlQHk57LvfLicwiaANqeAnoX5WexlyvYF2icN41QYUJXuvd39ZIW72qibkumrYYTHcg/0";
            break;
        }
        case 2:
        {
            info.showName = @"梦开始的地方";
            info.avatarUrlString = @"http://wx.qlogo.cn/mmopen/vi_32/4vrPLRibJhPwpia1GXX6dAU2TLFgqXAgacvYGibz1nLjK5azR3HqXkYwsOPPiaZ6Uqla13PyUMm4ZVicJnZDMSF7VqA/132";
            break;
        }
        case 3:
        {
            info.showName = @"微测5";
            info.avatarUrlString = @"http://thirdwx.qlogo.cn/mmopen/vi_32/nX05EhtcqNF6nx0mPuZ0Lxtzicn1VrzADrHJAhwawbXkjiaCelbWkMavqrXv2ibXGk1PGD4dz59mia03jSEniblhmWA/132";
            break;
        }
        case 4:
        {
            info.showName = @"茜茜";
            info.avatarUrlString = @"http://wx.qlogo.cn/mmopen/vi_32/bJnPibUhzcdPfpoMVcfptyltQyCwEn1riaKPLtibyAVav5xBNTk9f9JpYfecIqvOicddIvKONUZgPtEEbd70ENPXaQ/0";
            break;
        }
        case 5:
        {
            info.showName = @"禄丰小茶馆客服";
            info.avatarUrlString = @"http://thirdwx.qlogo.cn/mmopen/vi_32/gAiamvAz5uJCpTicCWIRjq8qAOicenRZ76yz4P198t2yTWAHh5yWUp4ibG4iatb7cqQficTeF7fqpXJ9p0xpk7WT6UVw/132";
            break;
        }
        case 6:
        {
            info.showName = @"天天忙不完";
            info.avatarUrlString = @"http://wx.qlogo.cn/mmopen/vi_32/NZ55uMnadKn3CpDricB2akfpaMejUmk3iahdhYbcUbaNCsWVbyibKQGSj5tjibfu4qt32E1nBTkjjmobzE8d8qzkRA/0";
            break;
        }
        case 7:
        {
            info.showName = @"只因为你";
            info.avatarUrlString = @"http://wx.qlogo.cn/mmopen/vi_32/NZ55uMnadKn3CpDricB2akfpaMejUmk3iahdhYbcUbaNCsWVbyibKQGSj5tjibfu4qt32E1nBTkjjmobzE8d8qzkRA/0";
            break;
        }
        case 8:
        {
            info.showName = @"小气";
            info.avatarUrlString = @"";
            break;
        }
        case 9:
        {
            info.showName = @"onlyヽMe灬";
            info.avatarUrlString = @"http://wx.qlogo.cn/mmopen/vi_32/aCupASeHg6bzY97W28iaHEm7G3BrnDoYdpBDXTKOvROzruI0yrUZB87padlPtm7DNl1ZmN2o2TM6YVVhuERmib7g/0";
            break;
        }
        default:
            break;
    }
    
    return info;
}

-(void)loadContact
{
    if (!_groupData) {
        _groupData = [[NSMutableArray<JXContactGroupData *> alloc] init];
    }
    if (!_titleIndex) {
        _titleIndex = [[NSMutableDictionary<NSString *,NSNumber *> alloc] init];
    }
    _nimUserCount = 0;
    [_titleIndex removeAllObjects];
    [_groupData removeAllObjects];
    
    //添加系统组
    JXContactGroupData *systemGroup = [[JXContactGroupData alloc] initWithTitle:@"system" groupTpe:JXContactGroupTypeSystemGroup];
    [systemGroup addMember:[[JXContactMemberData alloc] initWithMemberType:JXContactMemberTypeSystemNewFriend] sortMember:NO];
    [systemGroup addMember:[[JXContactMemberData alloc] initWithMemberType:JXContactMemberTypeSystemInviteWXFriend] sortMember:NO];
    [systemGroup addMember:[[JXContactMemberData alloc] initWithMemberType:JXContactMemberTypeSystemGroupChat] sortMember:NO];
    [systemGroup addMember:[[JXContactMemberData alloc] initWithMemberType:JXContactMemberTypeSystemBlacklist] sortMember:NO];
    [systemGroup addMember:[[JXContactMemberData alloc] initWithMemberType:JXContactMemberTypeSystemPhoneContact] sortMember:NO];
    [systemGroup addMember:[[JXContactMemberData alloc] initWithMemberType:JXContaceMemberTypeSystemHelper] sortMember:NO];
    [_groupData addObject:systemGroup];
    
    //分组添加好友列表
    NSMutableDictionary<NSString *,NSMutableArray<JXContactMemberData *> *> *dict_tmp = [[NSMutableDictionary alloc] init];
    
    /*for (int i=0; i<10; i++) {
        NIMKitInfo *info = [self testData:i];
        JXContactMemberData *memberData = [[JXContactMemberData alloc] initWithNimKitInfo:info
                                                                               memberType:JXContactMemberTypeNIMUser];
        
        NSString *groupTitle = [memberData.contactDataUniProtocol groupTitle];
        NSMutableArray<JXContactMemberData *> *members = [dict_tmp objectForKey:groupTitle];
        if (!members) {
            members = [[NSMutableArray<JXContactMemberData *> alloc] init];
        }
        ++_nimUserCount;
        [members addObject:memberData];
        [dict_tmp setObject:members forKey:groupTitle];
    }
    */
    
    for (NIMUser *user in [NIMSDK sharedSDK].userManager.myFriends) {
        NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:user.userId option:nil];
        JXContactMemberData *memberData = [[JXContactMemberData alloc] initWithNimKitInfo:info
                                                                               memberType:JXContactMemberTypeNIMUser];
        
        NSString *groupTitle = [memberData.contactDataUniProtocol groupTitle];
        NSMutableArray<JXContactMemberData *> *members = [dict_tmp objectForKey:groupTitle];
        if (!members) {
            members = [[NSMutableArray<JXContactMemberData *> alloc] init];
        }
        ++_nimUserCount;
        [members addObject:memberData];
        [dict_tmp setObject:members forKey:groupTitle];
    }
    
    //根据组名排序添加至组数组中
    if (dict_tmp.count > 0) {
        [[dict_tmp.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 isEqualToString:@"#"]) {
                return NSOrderedDescending;
            }
            if ([obj2 isEqualToString:@"#"]) {
                return NSOrderedAscending;
            }
            return [obj1 compare:obj2];
        }] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [_titleIndex setObject:[NSNumber numberWithUnsignedInteger:idx] forKey:[NSString stringWithString:obj]];
            JXContactGroupData *userGroup = [[JXContactGroupData alloc] initWithTitle:obj groupTpe:JXContactGroupTypeNIMUser];
            [userGroup addMembers:[dict_tmp objectForKey:obj] sortMembers:YES];
            [_groupData addObject:userGroup];
            
        }];
    }
}

- (NSInteger)nimUserCount
{
    return _nimUserCount;
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

- (NSInteger)groupIdxOfTtitle:(NSString *)title
{
    NSNumber *index = _titleIndex[title];
    if (!index) {
        return -1;
    }
    return [index integerValue];
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
