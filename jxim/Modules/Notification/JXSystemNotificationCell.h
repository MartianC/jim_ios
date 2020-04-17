//
//  JXSystemNotificationCell.h
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, NotificationHandleType) {
    NotificationHandleTypePending = 0,
    NotificationHandleTypeOk,
    NotificationHandleTypeNo,
    NotificationHandleTypeOutOfDate
};

@class NIMSystemNotification;

@protocol NIMSystemNotificationCellDelegate <NSObject>
- (void)onAccept:(NIMSystemNotification *)notification;
- (void)onRefuse:(NIMSystemNotification *)notification;
@end


@interface JXSystemNotificationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *handleInfoLabel;
@property (strong, nonatomic) IBOutlet UIView *acceptButton;
@property (strong, nonatomic) IBOutlet UIView *refuseButton;
@property (weak, nonatomic) id<NIMSystemNotificationCellDelegate> actionDelegate;
- (void)update:(NIMSystemNotification *)notification;
@end
