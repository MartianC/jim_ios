//
//  JXNotificationCenter.m
//

#import "JXNotificationCenter.h"
#import "JXMainTBC.h"
#import "JXSessionViewController.h"
#import "NSDictionary+DictionaryExt.h"
#import "JXCustomNotificationDB.h"
#import "JXCustomNotificationObject.h"
#import "UIView+Toast.h"
#import "JXCustomSysNotificationSender.h"
#import <AVFoundation/AVFoundation.h>
#import "JXSessionMsgConverter.h"
#import "JXSessionUtil.h"
#import "JXAVNotifier.h"
#import "JXRedPacketTipAttachment.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMKit.h>
#import "JXSessionUtil.h"

NSString *JXCustomNotificationCountChanged = @"JXCustomNotificationCountChanged";

@interface JXNotificationCenter () <NIMSystemNotificationManagerDelegate,NIMChatManagerDelegate,NIMBroadcastManagerDelegate, NIMSignalManagerDelegate, NIMConversationManagerDelegate>

@property (nonatomic,strong) AVAudioPlayer *player; //播放提示音
@property (nonatomic,strong) JXAVNotifier *notifier;

@end

@implementation JXNotificationCenter

+ (instancetype)sharedCenter
{
    static JXNotificationCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JXNotificationCenter alloc] init];
    });
    return instance;
}

- (void)start
{
    NSLog(@"Notification Center Setup");
}

- (instancetype)init {
    self = [super init];
    if(self) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"message" withExtension:@"wav"];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _notifier = [[JXAVNotifier alloc] init];
        
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        [[NIMSDK sharedSDK].broadcastManager addDelegate:self];
        
        [[NIMSDK sharedSDK].signalManager addDelegate:self];
        [[NIMSDK sharedSDK].conversationManager addDelegate:self];
        
    }
    return self;
}


- (void)dealloc{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMSDK sharedSDK].broadcastManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
}

#pragma mark - NIMConversationDelegate

- (void)didServerSessionUpdated:(NIMRecentSession *)recentSession {
    [[UIApplication sharedApplication].keyWindow.rootViewController.view makeToast:[NSString stringWithFormat:@"%@",recentSession.serverExt] duration:1 position:CSToastPositionCenter];
}

#pragma mark - NIMChatManagerDelegate
- (void)onRecvMessages:(NSArray *)recvMessages
{
    NSArray *messages = [self filterMessages:recvMessages];
    if (messages.count)
    {
        static BOOL isPlaying = NO;
        if (isPlaying) {
            return;
        }
        isPlaying = YES;
        [self playMessageAudioTip];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isPlaying = NO;
        });
        [self checkMessageAt:messages];
    }
}

- (void)playMessageAudioTip
{
    UINavigationController *nav = [JXMainTBC instance].selectedViewController;
    BOOL needPlay = YES;
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:[NIMSessionViewController class]])
        {
            needPlay = NO;
            break;
        }
    }
    if (needPlay) {
        [self.player stop];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error:nil];
        [self.player play];
    }
}

- (void)checkMessageAt:(NSArray<NIMMessage *> *)messages
{
    //一定是同个 session 的消息
    NIMSession *session = [messages.firstObject session];
    if ([self.currentSessionViewController.session isEqual:session])
    {
        //只有在@所属会话页外面才需要标记有人@你
        return;
    }

    NSString *me = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    for (NIMMessage *message in messages) {
        if ([message.apnsMemberOption.userIds containsObject:me]) {
            [JXSessionUtil addRecentSessionMark:session type:JXRecentSessionMarkTypeAt];
            return;
        }
    }
}


- (NSArray *)filterMessages:(NSArray *)messages
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NIMMessage *message in messages)
    {
        if ([self checkRedPacketTip:message] && ![self canSaveMessageRedPacketTip:message])
        {
            [[NIMSDK  sharedSDK].conversationManager deleteMessage:message];
            [self.currentSessionViewController uiDeleteMessage:message];
            continue;
        }
        [array addObject:message];
    }
    return [NSArray arrayWithArray:array];
}


- (BOOL)checkRedPacketTip:(NIMMessage *)message
{
    NIMCustomObject *object = message.messageObject;
    if ([object isKindOfClass:[NIMCustomObject class]] && [object.attachment isKindOfClass:[JXRedPacketTipAttachment class]])
    {
        return YES;
    }
    return NO;
}

- (BOOL)canSaveMessageRedPacketTip:(NIMMessage *)message
{
    NIMCustomObject *object = message.messageObject;
    JXRedPacketTipAttachment *attach = (JXRedPacketTipAttachment *)object.attachment;
    NSString *me = [NIMSDK sharedSDK].loginManager.currentAccount;
    return [attach.sendPacketId isEqualToString:me] || [attach.openPacketId isEqualToString:me];
}

- (void)onRecvRevokeMessageNotification:(NIMRevokeMessageNotification *)notification
{
    NIMMessage *tipMessage = [JXSessionMsgConverter msgWithTip:[JXSessionUtil tipOnMessageRevoked:notification]];
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.shouldBeCounted = NO;
    tipMessage.setting = setting;
    tipMessage.timestamp = notification.timestamp;
    
    JXMainTBC *tabVC = [JXMainTBC instance];
    UINavigationController *nav = tabVC.selectedViewController;

    for (JXSessionViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:[JXSessionViewController class]]
            && [vc.session.sessionId isEqualToString:notification.session.sessionId]) {
            NIMMessageModel *model = [vc uiDeleteMessage:notification.message];
            if (notification.notificationType == NIMRevokeMessageNotificationTypeP2POneWay ||
                notification.notificationType == NIMRevokeMessageNotificationTypeTeamOneWay)
            {
                break;
            }
            
            if (model) {
                [vc uiInsertMessages:@[tipMessage]];
            }
            break;
        }
    }
    
    // saveMessage 方法执行成功后会触发 onRecvMessages: 回调，但是这个回调上来的 NIMMessage 时间为服务器时间，和界面上的时间有一定出入，所以要提前先在界面上插入一个和被删消息的界面时间相符的 Tip, 当触发 onRecvMessages: 回调时，组件判断这条消息已经被插入过了，就会忽略掉。
    if (notification.notificationType != NIMRevokeMessageNotificationTypeP2POneWay &&
        notification.notificationType != NIMRevokeMessageNotificationTypeTeamOneWay)
    {
        [[NIMSDK sharedSDK].conversationManager saveMessage:tipMessage
                                                 forSession:notification.session
                                                 completion:nil];
    }
    
}

- (void)onRecvMessageDeleted:(NIMMessage *)message ext:(NSString *)ext
{

    JXMainTBC *tabVC = [JXMainTBC instance];
    UINavigationController *nav = tabVC.selectedViewController;

    for (JXSessionViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:[JXSessionViewController class]]
            && [vc.session.sessionId isEqualToString:message.session.sessionId]) {
            [vc uiDeleteMessage:message];
        }
    }
}


#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
    
    NSString *content = notification.content;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            switch ([dict jsonInteger:JXNotifyID]) {
                case JXCustom:{
                    //SDK并不会存储自定义的系统通知，需要上层结合业务逻辑考虑是否做存储。这里给出一个存储的例子。
                    JXCustomNotificationObject *object = [[JXCustomNotificationObject alloc] initWithNotification:notification];
                    //这里只负责存储可离线的自定义通知，推荐上层应用也这么处理，需要持久化的通知都走可离线通知
                    if (!notification.sendToOnlineUsersOnly) {
                        [[JXCustomNotificationDB sharedInstance] saveNotification:object];
                    }
                    if (notification.setting.shouldBeCounted) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:JXCustomNotificationCountChanged object:nil];
                    }
                    NSString *content  = [dict jsonString:JXCustomContent];
                    [self makeToast:content];
                    break;
                }
                default:
                    break;
            }
        }
    }
}

#pragma mark - NIMNetCallManagerDelegate

- (void)onRTSTerminate:(NSString *)sessionID
                    by:(NSString *)user
{
    [_notifier stop];
}

- (BOOL)shouldResponseBusy
{
    return NO;
//    JXMainTBC *tabVC = [JXMainTBC instance];
//    UINavigationController *nav = tabVC.selectedViewController;
//    return [nav.topViewController isKindOfClass:[JXNetChatViewController class]] ||
//    [tabVC.presentedViewController isKindOfClass:[JXWhiteboardViewController class]] ||
//    [tabVC.presentedViewController isKindOfClass:[JXTeamMeetingCallingViewController class]] ||
//    [tabVC.presentedViewController isKindOfClass:[JXTeamMeetingViewController class]];
}

#pragma mark - NIMBroadcastManagerDelegate
- (void)onReceiveBroadcastMessage:(NIMBroadcastMessage *)broadcastMessage
{
    [self makeToast:broadcastMessage.content];
}

#pragma mark - format

- (BOOL)shouldFireNotification:(NSString *)callerId
{
    //退后台后 APP 存活，然后收到通知
    BOOL should = YES;
 
    //消息不提醒
    id<NIMUserManager> userManager = [[NIMSDK sharedSDK] userManager];
    if (![userManager notifyForNewMsg:callerId])
    {
        should = NO;
    }
    
    //当前在正处于免打扰
    id<NIMApnsManager> apnsManager = [[NIMSDK sharedSDK] apnsManager];
    NIMPushNotificationSetting *setting = [apnsManager currentSetting];
    if (setting.noDisturbing)
    {
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
        NSInteger now = components.hour * 60 + components.minute;
        NSInteger start = setting.noDisturbingStartH * 60 + setting.noDisturbingStartM;
        NSInteger end = setting.noDisturbingEndH * 60 + setting.noDisturbingEndM;

        //当天区间
        if (end > start && end >= now && now >= start)
        {
            should = NO;
        }
        //隔天区间
        else if(end < start && (now <= end || now >= start))
        {
            should = NO;
        }
    }

    return should;
}

- (NIMSessionViewController *)currentSessionViewController
{
    UINavigationController *nav = [JXMainTBC instance].selectedViewController;
    for (UIViewController *vc in nav.viewControllers)
    {
        if ([vc isKindOfClass:[NIMSessionViewController class]])
        {
            return (NIMSessionViewController *)vc;
        }
    }
    return nil;
}

- (void)makeToast:(NSString *)content
{
    [[JXMainTBC instance].selectedViewController.view makeToast:content duration:2.0 position:CSToastPositionCenter];
}


@end
