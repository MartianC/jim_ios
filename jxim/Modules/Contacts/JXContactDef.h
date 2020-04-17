//
//  JXContactDef.h
//  jxim
//
//  Created by yangfantao on 2020/3/26.
//  Copyright © 2020 jxwl. All rights reserved.
//

#ifndef JXContactDef_h
#define JXContactDef_h

#import "NIMContactDefines.h"

#define ContactRowHeight_System 57.0f
#define ContaceItemCellReUseID @"__ContaceItemCellReUseID__"

/**
 * 联系人组类型
 */
typedef NS_ENUM(NSUInteger,JXContactGroupType){
    /**
     * 系统组
     */
    JXContactGroupTypeSystemGroup = 0,
    /**
     * 用户组
     */
    JXContactGroupTypeNIMUser,
    /**
     * 群聊组
     */
    JXContactGroupTypeNIMGroupChat
};

/**
 * 联系人数据成员类型
 */
typedef NS_ENUM(NSUInteger, JXContactMemberType) {
    /**
     * 新的好友，点击前往好友验证列表
     */
    JXContactMemberTypeSystemNewFriend,
    /**
     * 邀请微信好友，点击分享给微信好友或者分享至微信朋友圈
     */
    JXContactMemberTypeSystemInviteWXFriend,
    /**
     * 群聊，点击显示我的所有群聊
     */
    JXContactMemberTypeSystemGroupChat,
    /**
     * 手机联系人，点击读取手机通讯录好友，并以短信的形式邀请好友下载
     */
    JXContactMemberTypeSystemPhoneContact,
    /**
     * 黑名单
     */
    JXContactMemberTypeSystemBlacklist,
    /**
     * 游聊助手
     */
    JXContaceMemberTypeSystemHelper,
    /**
     *扫一扫
     */
    JXContaceMemberTypeSystemScan,
    /**
     * 好友
     */
    JXContactMemberTypeNIMUser,
    /**
     * 群聊
     */
    JXContactMemberTypeNIMGroupChat
};

@protocol JXContactMemberProtocol <NSObject>

@required

- (JXContactMemberType)contactMemberType;
- (NSString *)reuseId;
- (NSString *)cellClassName;
- (CGFloat)rowHeight;
- (NSString *)identity;
- (NSString *)badgeValue;

@end

@protocol JXContactDataSortProtocol <NSObject>

@required

- (NSString *)sortValue;

@end

@protocol JXSystemContactDataProviderProtocol <NSObject,JXContactMemberProtocol,NIMGroupMemberProtocol>



@end

@protocol JXContactGroupDataProtocol <NSObject>

@required

- (NSString *)title;
- (NSInteger)memberNum;

@end

@protocol JXContactDataUniProtocol <NSObject>

@required

- (id<NIMGroupMemberProtocol>) nimGroupMember;
- (id<JXContactMemberProtocol>) jxContactMember;
- (id<JXContactDataSortProtocol>) sortProtocol;
- (id<JXSystemContactDataProviderProtocol>) systemContactDataProvider;
- (NSString *)groupTitle;

@end

#endif /* JXContactDef_h */
