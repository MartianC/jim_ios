//
//  JXBundleSetting.m
//  jxim
//
//  Created by yangfantao on 2020/4/9.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXBundleSetting.h"

//部分API提供了额外的选项，如删除消息会有是否删除会话的选项,为了测试方便提供配置参数
//上层开发只需要按照策划需求选择一种适合自己项目的选项即可，这个设置只是为了方便测试不同的case下API的正确性

@implementation JXBundleSetting


+ (instancetype)sharedConfig
{
    static JXBundleSetting *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JXBundleSetting alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if(self = [super init]) {
        [self checkSocks5DefaultSetting];
        NSDictionary *dict = @{
                               @"exception_upload_log_enabled" : @(NO),
                               @"custom_apns_content_type" : @"custom"
                               };
        [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
    }
    return self;
}

- (void)checkSocks5DefaultSetting {
    NSString *settingBundlePath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    NSString *plistPath = [settingBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *preferences = [plistDict valueForKey:@"PreferenceSpecifiers"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    for(NSDictionary *setting in preferences) {
        // 如果NSUserDefaults里有，则优先使用UserDefaults里的
        NSString *key = [setting valueForKey:@"Key"];
        
        if (key && key.length>0 && [key containsString:@"socks5"]) {
            // 从Plist中获取值填充
            id value = [setting valueForKey:@"DefaultValue"];
            if(value) {
                [userDefaults setObject:value forKey:key];
            }
        }
    }
}

- (BOOL)removeSessionWhenDeleteMessages{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled_remove_recent_session"] boolValue];
}

- (BOOL)dropTableWhenDeleteMessages
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled_drop_msg_table"] boolValue];
}

- (BOOL)localSearchOrderByTimeDesc{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"local_search_time_order_desc"] boolValue];
}

- (BOOL)autoRemoveRemoteSession
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"auto_remove_remote_session"] boolValue];
}

- (BOOL)autoRemoveAlias
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"auto_remove_alias"] boolValue];
}

- (BOOL)needVerifyForFriend
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"add_friend_need_verify"] boolValue];
}

- (BOOL)showFps{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"show_fps_for_app"] boolValue];
}

- (BOOL)disableProximityMonitor
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"disable_proxmity_monitor"] boolValue];
}

- (BOOL)animatedImageThumbnailEnabled
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"animated_image_thumbnail_enabled"] boolValue];
}

- (BOOL)enableRotate
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"enable_rotate"] boolValue];
}

- (BOOL)usingAmr
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"using_amr"] boolValue];
}

- (BOOL)enableAPNsPrefix
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:@"enable_apns_prefix"];
    if(value) {
        return [value boolValue];
    }else {
        return YES;
    }
}

- (BOOL)enableTeamAPNsForce
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:@"enable_team_apns_force"];
    if (value) {
        return [value boolValue];
    }
    else
    {
        return NO;
    }
}

- (BOOL)enableAudioSessionReset
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:@"disable_audio_session_reset"];
    if (value) {
        return [value boolValue];
    }
    else
    {
        return NO;
    }
}

- (BOOL)exceptionLogUploadEnabled
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:@"exception_upload_log_enabled"];
    if (value) {
        return [value boolValue];
    }
    else
    {
        return NO;
    }
}

- (BOOL)enableLocalAnti
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:@"enable_local_anti"];
    if (value)
    {
        return [value boolValue];
    }
    else
    {
        return NO;
    }
}

- (BOOL)enableSdkRemoteRender
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:@"enable_sdk_video_render"];
    if (value)
    {
        return [value boolValue];
    }
    else
    {
        return NO;
    }
}

- (BOOL)enableSyncWhenFetchRemoteMessages
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"sync_when_remote_fetch_messages"] boolValue];
}

- (BOOL)countTeamNotification
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"count_team_notification"] boolValue];
}


- (NSArray *)ignoreTeamNotificationTypes
{
    static NSArray *types = nil;
    if (types == nil)
    {
        NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"ignore_team_types"];
        if ([value isKindOfClass:[NSString class]])
        {
            NSString *typeDescription = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([typeDescription length])
            {
                types = [typeDescription componentsSeparatedByString:@","];
            }
        }
    }
    if (types == nil)
    {
        types = [NSArray array];
    }
    return types;
}


- (BOOL)serverRecordAudio
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"server_record_audio"] boolValue];
}

- (BOOL)serverRecordHost
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"server_record_host"] boolValue];
}

- (int)serverRecordMode
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"server_record_mode"] intValue];
}

- (BOOL)useSocks
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"use_socks5"] boolValue];
}

- (NSString *)customAPNsType
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"custom_apns_content_type"];
}

- (NSString *)socks5Addr
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"socks5_addr"]? : @"";
}

- (NSUInteger)socks5Type
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"socks5_type"] intValue];
}
            
- (NSString *)socksUsername
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"socks5_username"]? : @"";
}

- (NSString *)socksPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"socks5_password"] ?: @"";
}

- (BOOL)serverRecordWhiteboardData
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"server_record_whiteboard_data"] boolValue];
}

- (NSInteger)maximumLogDays
{
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:@"maximum_log_days"];
    NSInteger days = object? [object integerValue]: 7;
    return days;
}

- (UIViewContentMode)videochatRemoteVideoContentMode
{
    NSInteger setting = [[[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_remote_video_content_mode"] integerValue];
    return (setting == 0) ? UIViewContentModeScaleAspectFill : UIViewContentModeScaleAspectFit;
}

- (BOOL)autoDeactivateAudioSession
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_auto_disable_audiosession"];
    
    if (setting) {
        return [setting boolValue];
    }
    else {
        return YES;
    }
}

- (BOOL)audioDenoise
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_audio_denoise"];
    
    if (setting) {
        return [setting boolValue];
    }
    else {
        return YES;
    }
    
}

- (BOOL)voiceDetect
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_voice_detect"];
    
    if (setting) {
        return [setting boolValue];
    }
    else {
        return YES;
    }
    
}

- (BOOL)preferHDAudio
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_prefer_hd_audio"];
    
    if (setting) {
        return [setting boolValue];
    }
    else {
        return NO;
    }
}

- (BOOL)autoFetchAttachment
{
    id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"auto_fetch_attachment"];
    if (setting) {
        return [setting boolValue];
    } else {
        return YES;
    }
}

- (NIMAsymEncryptionType)AsymEncryptionType {
    id ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"nim_asym_crypto_type"];
    return (ret == nil ? 1 : [ret integerValue]);
}

- (NIMSymEncryptionType)SymEncryptionType {
    id ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"nim_sym_crypto_type"];
    return (ret == nil ? 1 : [ret integerValue]);
}

- (NIMLinkAddressType)LbsLinkAddressType {
    id ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"nim_link_address_type"];
    return [ret integerValue];
}

- (NSString *)ipv4DefaultLink {
    id ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"ipv4_default_link"];
    return ret;
}

- (NSString *)ipv6DefaultLink {
    id ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"ipv6_default_link"];
    return ret;
}

- (BOOL)asyncLoadRecentSessionEnabled {
    id ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"tester_recent_session_most_enable"];
    return [ret boolValue];
}

- (NSInteger)ignoreMessageType {
    id ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"ignore_message_type"];
    if (ret) {
        return [ret integerValue];
    }
    return -1;
}

- (BOOL)isDeleteMsgFromServer
{
    id ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"menu_delete_msg_from_server"];
    return [ret boolValue];
}

- (BOOL)isIgnoreRevokeMessageCount
{
    id ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"enable_revoke_count"];
    return [ret boolValue];
}
/*
- (NSString *)description
{
    return [NSString stringWithFormat:
                @"\n\n\n" \
                "enabled_remove_recent_session %d\n" \
                "local_search_time_order_desc %d\n" \
                "auto_remove_remote_session %d\n" \
                "auto_remove_alias %d\n" \
                "auto_remove_snap_message %d\n" \
                "add_friend_need_verify %d\n" \
                "show app %d\n" \
                "maximum log days %zd\n" \
                "using amr %d\n" \
                "ignore_team_types %@ \n" \
                "server_record_audio %d\n" \
                "server_record_video %d\n" \
                "server_record_whiteboard_data %d\n" \
                "videochat_video_crop %zd\n" \
                "videochat_auto_rotate_remote_video %d \n" \
                "videochat_preferred_video_quality %zd\n" \
                "videochat_start_with_back_camera %zd\n" \
                "videochat_preferred_video_encoder %zd\n" \
                "videochat_preferred_video_decoder %zd\n" \
                "videochat_video_encode_max_kbps %zd\n" \
                "videochat_local_record_video_kbps %zd\n" \
                "videochat_local_record_video_quality %zd\n" \
                "videochat_auto_disable_audiosession %zd\n" \
                "videochat_audio_denoise %zd\n" \
                "videochat_voice_detect %zd\n" \
                "videochat_prefer_hd_audio %zd\n"\
                "avchat_scene %zd\n"\
                "chatroom_retry_count %zd\n"\
                "sync_when_remote_fetch_messages %zd\n"\
                "enable_revoke_count %zd\n"\
                "\n\n\n",
                [self removeSessionWhenDeleteMessages],
                [self localSearchOrderByTimeDesc],
                [self autoRemoveRemoteSession],
                [self autoRemoveAlias],
                [self autoRemoveSnapMessage],
                [self needVerifyForFriend],
                [self showFps],
                [self maximumLogDays],
                [self usingAmr],
                [self ignoreTeamNotificationTypes],
                [self serverRecordAudio],
                [self serverRecordVideo],
                [self serverRecordWhiteboardData],
                [self videochatVideoCrop],
                [self videochatAutoRotateRemoteVideo],
                [self preferredVideoQuality],
                [self startWithBackCamera],
                [self perferredVideoEncoder],
                [self perferredVideoDecoder],
                [self videoMaxEncodeKbps],
                [self localRecordVideoKbps],
                [self localRecordVideoQuality],
                [self autoDeactivateAudioSession],
                [self audioDenoise],
                [self voiceDetect],
                [self preferHDAudio],
                [self scene],
                [self chatroomRetryCount],
                [self enableSyncWhenFetchRemoteMessages],
                [self isIgnoreRevokeMessageCount]
            ];
}
*/

@end
