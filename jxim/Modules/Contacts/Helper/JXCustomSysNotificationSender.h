//
//  JXCustomSysNotiSender.h
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

#define JXNotifyID        @"id"
#define JXCustomContent   @"content"
#define JXTeamMeetingMembers   @"members"
#define JXTeamMeetingTeamId    @"teamId"
#define JXTeamMeetingTeamName  @"teamName"
#define JXTeamMeetingType      @"teamType"
#define JXTeamMeetingName      @"room"

#define JXCommandTyping   (1)
#define JXCustom          (2)
#define JXTeamMeetingCall (3)

@interface JXCustomSysNotificationSender : NSObject

- (void)sendCustomContent:(NSString *)content toSession:(NIMSession *)session;

- (void)sendTypingState:(NIMSession *)session;

- (void)sendCallNotification:(NIMTeam *)team
                    roomName:(NSString *)roomName
                     members:(NSArray *)members;

@end
