//
//  JXContactMemberData.m
//  jxim
//
//  Created by yangfantao on 2020/3/26.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXContactMemberData.h"
#import "JXSpellingCenter.h"
#import <NIMKit.h>

@interface JXContactMemberData()

@property(nonatomic,strong) NIMKitInfo *nimKitInfo;
@property(nonatomic,assign) JXContactMemberType memberType;
@property(nonatomic,copy) NSString *identity;

@end

@implementation JXContactMemberData

-(instancetype)initWithNimKitInfo:(nullable NIMKitInfo *)kitInfo memberType:(JXContactMemberType)type
{
    if (self = [super init]) {
        [self initData:kitInfo memberType:type];
    }
    return self;
}

-(instancetype)initWithMemberType:(JXContactMemberType)type
{
    if (self = [super init]) {
        [self initData:nil memberType:type];
    }
    return self;
}

-(void)initData:(NIMKitInfo *)kitInfo memberType:(JXContactMemberType)type
{
    _memberType = type;
    _identity = @"";
    switch (_memberType) {
        case JXContactMemberTypeNIMUser:
        {
            _nimKitInfo = kitInfo;
            break;
        }
        case JXContactMemberTypeSystemNewFriend:
        {
            _nimKitInfo = [[NIMKitInfo alloc] init];
            _nimKitInfo.infoId = @"id_JXContactMemberTypeSystemNewFriend";
            _nimKitInfo.showName = @"新的朋友";
            _nimKitInfo.avatarUrlString = nil;
            _nimKitInfo.avatarImage = [UIImage imageNamed:@"icon_contact_system_newfriend"];
            break;
        }
        case JXContactMemberTypeSystemInviteWXFriend:
        {
            _nimKitInfo = [[NIMKitInfo alloc] init];
            _nimKitInfo.infoId = @"id_JXContactMemberTypeInviteWXFriend";
            _nimKitInfo.showName = @"邀请微信好友";
            _nimKitInfo.avatarUrlString = nil;
            _nimKitInfo.avatarImage = [UIImage imageNamed:@"icon_contact_system_wechatfriend"];
            break;
        }
        case JXContactMemberTypeSystemGroupChat:
        {
            _nimKitInfo = [[NIMKitInfo alloc] init];
            _nimKitInfo.infoId = @"id_JXContactMemberTypeGroupChat";
            _nimKitInfo.showName = @"群聊";
            _nimKitInfo.avatarUrlString = nil;
            _nimKitInfo.avatarImage = [UIImage imageNamed:@"icon_contact_system_groupchat"];
            break;
        }
        case JXContactMemberTypeSystemBlacklist:
        {
            _nimKitInfo = [[NIMKitInfo alloc] init];
            _nimKitInfo.infoId = @"id_JXContactMemberTypeSystemBlacklist";
            _nimKitInfo.showName = @"黑名单";
            _nimKitInfo.avatarUrlString = nil;
            _nimKitInfo.avatarImage = [UIImage imageNamed:@"icon_contact_system_blacklist"];
            break;
        }
        case JXContactMemberTypeSystemPhoneContact:
        {
            _nimKitInfo = [[NIMKitInfo alloc] init];
            _nimKitInfo.infoId = @"id_JXContactMemberTypePhoneContact";
            _nimKitInfo.showName = @"手机联系人";
            _nimKitInfo.avatarUrlString = nil;
            _nimKitInfo.avatarImage = [UIImage imageNamed:@"icon_contact_system_phonecontact"];
            break;
        }
        case JXContaceMemberTypeSystemScan:
        {
            _nimKitInfo = [[NIMKitInfo alloc] init];
            _nimKitInfo.infoId = @"id_JXContaceMemberTypeSystemScan";
            _nimKitInfo.showName = @"扫一扫";
            _nimKitInfo.avatarUrlString = nil;
            _nimKitInfo.avatarImage = [UIImage imageNamed:@"icon_contact_system_scan"];
            break;
        }
        case JXContaceMemberTypeSystemHelper:
        {
            _nimKitInfo = [[NIMKitInfo alloc] init];
            _nimKitInfo.infoId = @"id_JXContaceMemberTypeHelper";
            _nimKitInfo.showName = @"游聊助手";
            _nimKitInfo.avatarUrlString = nil;
            _nimKitInfo.avatarImage = [UIImage imageNamed:@"icon_contact_system_helper"];
            _identity = @"icon_contact_identity_system";
            break;
        }
        
        default:
            break;
    }
}

-(id<JXContactDataUniProtocol>) contactDataUniProtocol
{
    return self;
}

#pragma mark - JXContactDataSortProtocol

-(NSString *)sortValue
{
    return [[JXSpellingCenter sharedCenter] spellingForString:self.showName].shortSpelling;
}

#pragma mark - JXContactDataUniProtocol

- (id<NIMGroupMemberProtocol>) nimGroupMember
{
    return self;
}

- (id<JXContactMemberProtocol>) jxContactMember
{
    return self;
}

- (id<JXContactDataSortProtocol>) sortProtocol
{
    return self;
}

- (id<JXSystemContactDataProviderProtocol>) systemContactDataProvider
{
    return self;
}

#pragma mark - JXContactMemberDataProtocol

- (JXContactMemberType)contactMemberType
{
    return _memberType;
}

- (NSString *)reuseId
{
    if (_memberType == JXContactMemberTypeNIMUser || _memberType == JXContactMemberTypeNIMGroupChat) {
        return @"__JXContactMemberTypeNIM__";
    }
    return @"__JXContactMemberTypeSystem__";
}

- (NSString *)cellClassName
{
    if (_memberType == JXContactMemberTypeNIMUser || _memberType == JXContactMemberTypeNIMGroupChat) {
        return @"JXContactDataCell";
    }
    return @"JXSystemContactCell";
}

- (CGFloat)rowHeight
{
    if (_memberType == JXContactMemberTypeNIMUser || _memberType == JXContactMemberTypeNIMGroupChat) {
        return NIMContactDataRowHeight;
    }
    return ContactRowHeight_System;
}

- (NSString *)identity
{
    return _identity;
}

- (NSString *)badgeValue
{
    if (_memberType == JXContactMemberTypeSystemNewFriend) {
        NIMSystemNotificationFilter *filter = [[NIMSystemNotificationFilter alloc] init];
        filter.notificationTypes = @[@(NIMSystemNotificationTypeTeamApply),
                                     @(NIMSystemNotificationTypeTeamApplyReject),
                                     @(NIMSystemNotificationTypeTeamInvite),
                                     @(NIMSystemNotificationTypeTeamIviteReject),
                                     @(NIMSystemNotificationTypeSuperTeamApply),
                                     @(NIMSystemNotificationTypeSuperTeamApplyReject),
                                     @(NIMSystemNotificationTypeSuperTeamInvite),
                                     @(NIMSystemNotificationTypeSuperTeamIviteReject)];
        NSInteger addFriendRequestCount = [NIMSDK.sharedSDK.systemNotificationManager allUnreadCount:filter];
        if (addFriendRequestCount > 0) {
            return [NSString stringWithFormat:@"%ld",(long)addFriendRequestCount];
        }
    }
    return @"";
}

#pragma mark - NIMGroupMemberProtocol

- (NSString *)groupTitle
{
    NSString *title = [[JXSpellingCenter sharedCenter] firstLetter:self.showName].capitalizedString;
    unichar character = [title characterAtIndex:0];
    if (character >= 'A' && character <= 'Z') {
        return title;
    }else{
        return @"#";
    }
}

- (NSString *)memberId
{
    if (!_nimKitInfo) {
        return @"";
    }
    return _nimKitInfo.infoId;
}

- (NSString *)showName
{
    if (!_nimKitInfo) {
        return @"";
    }
    return _nimKitInfo.showName;
}

- (NSString *)avatarUrlString
{
    if (!_nimKitInfo) {
        return nil;
    }
    return _nimKitInfo.avatarUrlString;
}

- (UIImage *)avatarImage
{
    if (!_nimKitInfo) {
        return nil;
    }
    return _nimKitInfo.avatarImage;
}

- (id)sortKey
{
    return [[JXSpellingCenter sharedCenter] spellingForString:self.showName].shortSpelling;
}

@end
