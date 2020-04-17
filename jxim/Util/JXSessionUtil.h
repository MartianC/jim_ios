//
//  JXSessionUtil.h
//  jxim
//
//  Created by yangfantao on 2020/4/9.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <NIMKit/NIMKit.h>
#import <NIMSDK/NIMSDK.h>

// 最近会话本地扩展标记类型
typedef NS_ENUM(NSInteger, JXRecentSessionMarkType){
    // @ 标记
    JXRecentSessionMarkTypeAt,
    // 置顶标记
    JXRecentSessionMarkTypeTop,
};

NS_ASSUME_NONNULL_BEGIN

@interface JXSessionUtil : NSObject


+ (CGSize)getImageSizeWithImageOriginSize:(CGSize)originSize
                                  minSize:(CGSize)imageMinSize
                                  maxSize:(CGSize)imageMaxSize;

+ (NSString *)showNick:(NSString*)uid inSession:(NIMSession*)session;

//接收时间格式化
+ (NSString*)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail;

+ (void)sessionWithInputURL:(NSURL*)inputURL
                  outputURL:(NSURL*)outputURL
               blockHandler:(void (^)(AVAssetExportSession*))handler;


+ (NSDictionary *)dictByJsonData:(NSData *)data;

+ (NSDictionary *)dictByJsonString:(NSString *)jsonString;

+ (BOOL)canMessageBeForwarded:(NIMMessage *)message;

+ (BOOL)canMessageBeRevoked:(NIMMessage *)message;

+ (BOOL)canMessageBeCanceled:(NIMMessage *)message;

+ (NSString *)tipOnMessageRevoked:(NIMRevokeMessageNotification *)notificaton;

+ (void)addRecentSessionMark:(NIMSession *)session type:(JXRecentSessionMarkType)type;

+ (void)removeRecentSessionMark:(NIMSession *)session type:(JXRecentSessionMarkType)type;

+ (BOOL)recentSessionIsMark:(NIMRecentSession *)recent type:(JXRecentSessionMarkType)type;

+ (NSString *)onlineState:(NSString *)userId detail:(BOOL)detail;

+ (NSString *)formatAutoLoginMessage:(NSError *)error;


@end

NS_ASSUME_NONNULL_END
