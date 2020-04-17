//
//  JXCustomSysNotiSender.m
//  NIM
//
//  Created by chris on 15/5/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "JXCustomSysNotificationSender.h"
#import "NIMKitInfoFetchOption.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMKit.h>

@interface JXCustomSysNotificationSender ()
@property (nonatomic,strong)    NSDate *lastTime;
@end

@implementation JXCustomSysNotificationSender

- (void)sendCustomContent:(NSString *)content toSession:(NIMSession *)session{
    if (!content) {
        return;
    }
    NSDictionary *dict = @{
                           JXNotifyID : @(JXCustom),
                           JXCustomContent : content,
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    NSString *json = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:json];
    notification.apnsContent = content;
    notification.sendToOnlineUsersOnly = NO;
    NIMCustomSystemNotificationSetting *setting = [[NIMCustomSystemNotificationSetting alloc] init];
    setting.apnsEnabled = YES;
    notification.setting = setting;
    [[[NIMSDK sharedSDK] systemNotificationManager] sendCustomNotification:notification
                                                                 toSession:session
                                                                completion:nil];
}


- (void)sendTypingState:(NIMSession *)session
{
    NSString *currentAccount = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    if (session.sessionType != NIMSessionTypeP2P ||
        [session.sessionId isEqualToString:currentAccount])
    {
        return;
    }
    
    NSDate *now = [NSDate date];
    if (_lastTime == nil ||
        [now timeIntervalSinceDate:_lastTime] > 3)
    {
        _lastTime = now;
        
        NSDictionary *dict = @{JXNotifyID : @(JXCommandTyping)};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:nil];
        NSString *content = [[NSString alloc] initWithData:data
                                                  encoding:NSUTF8StringEncoding];
        
        NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
        notification.sendToOnlineUsersOnly = YES;
        NIMCustomSystemNotificationSetting *setting = [[NIMCustomSystemNotificationSetting alloc] init];
        setting.apnsEnabled  = NO;
        notification.setting = setting;
        [[[NIMSDK sharedSDK] systemNotificationManager] sendCustomNotification:notification
                                                                     toSession:session
                                                                    completion:nil];
    }

}


- (void)sendCallNotification:(NIMTeam *)team
                    roomName:(NSString *)roomName
                     members:(NSArray *)members
{
    if (!team || !team.teamId || !members) {
        return;
    }
    
    NSString *teamId = team.teamId;
    NIMKitTeamType teamType = NIMKitTeamTypeNomal;
    if (team.type == NIMTeamTypeSuper) {
        teamType = NIMKitTeamTypeSuper;
    }
    NSDictionary *dict = @{
                           JXNotifyID : @(JXTeamMeetingCall),
                           JXTeamMeetingMembers : members,
                           JXTeamMeetingTeamId  : teamId,
                           JXTeamMeetingTeamName  : team.teamName? team.teamName : @"群组",
                           JXTeamMeetingName    : roomName,
                           JXTeamMeetingType    : @(teamType)
                          };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    NSString *content = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
    notification.sendToOnlineUsersOnly = NO;
    
    NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
    option.session = [NIMSession session:teamId type:NIMSessionTypeTeam];
    NIMKitInfo *me = [[NIMKit sharedKit] infoByUser:[NIMSDK sharedSDK].loginManager.currentAccount option:option];
    
    notification.apnsContent = [NSString stringWithFormat:@"%@%@",me.showName,@"正在呼叫您"];
    NIMCustomSystemNotificationSetting *setting = [[NIMCustomSystemNotificationSetting alloc] init];
    setting.apnsEnabled  = YES;
    notification.setting = setting;
    

    for (NSString *userId in members) {
        if ([userId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount])
        {
            continue;
        }
        NIMSession *session = [NIMSession session:userId type:NIMSessionTypeP2P];
        [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:nil];
    }

}




@end
