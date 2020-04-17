//
//  JXSessionMsgHelper.h
//  NIMDemo
//
//  Created by ght on 15-1-28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>

@class JXJanKenPonAttachment;
@class JXSnapchatAttachment;
@class JXChartletAttachment;
@class JXWhiteboardAttachment;
@class JXRedPacketAttachment;
@class JXRedPacketTipAttachment;
@class JXMultiRetweetAttachment;

@interface JXSessionMsgConverter : NSObject

+ (NIMMessage *)msgWithText:(NSString *)text;

+ (NIMMessage *)msgWithImage:(UIImage *)image;

+ (NIMMessage *)msgWithImagePath:(NSString *)path;

+ (NIMMessage *)msgWithAudio:(NSString *)filePath;

+ (NIMMessage *)msgWithVideo:(NSString *)filePath;

+ (NIMMessage *)msgWithJenKenPon:(JXJanKenPonAttachment *)attachment;

+ (NIMMessage *)msgWithSnapchatAttachment:(JXSnapchatAttachment *)attachment;

+ (NIMMessage *)msgWithChartletAttachment:(JXChartletAttachment *)attachment;

+ (NIMMessage *)msgWithWhiteboardAttachment:(JXWhiteboardAttachment *)attachment;

+ (NIMMessage *)msgWithFilePath:(NSString *)path;

+ (NIMMessage *)msgWithFileData:(NSData *)data extension:(NSString *)extension;

+ (NIMMessage *)msgWithTip:(NSString *)tip;

+ (NIMMessage *)msgWithRedPacket:(JXRedPacketAttachment *)attachment;

+ (NIMMessage *)msgWithRedPacketTip:(JXRedPacketTipAttachment *)attachment;

+ (NIMMessage *)msgWithMultiRetweetAttachment:(JXMultiRetweetAttachment *)attachment;

@end
