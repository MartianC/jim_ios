//
//  JXCustomNotificationObject.h
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

@interface JXCustomNotificationObject : NSObject


/**
 *  存储用的标识
 */
@property (nonatomic,assign)       NSInteger serial;

/**
 *  时间戳
 */
@property (nonatomic,assign)       NSTimeInterval timestamp;

/**
 *  通知发起者id
 */
@property (nonatomic,copy)         NSString *sender;

/**
 *  通知接受者id
 */
@property (nonatomic,copy)         NSString *receiver;

/**
 *  透传的消息体内容
 */
@property (nonatomic,copy)         NSString *content;


/**
 *  是否需要未读计数
 */
@property (nonatomic,assign)       BOOL needBadge;


- (instancetype)initWithNotification:(NIMCustomSystemNotification *)notification;


@end
