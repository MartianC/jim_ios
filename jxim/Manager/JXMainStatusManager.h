//
//  JXMainStatusManager.h
//  jxim
//
//  Created by yangfantao on 2020/3/21.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JXIMGlobalDef.h"

//头像压缩质量
#define ServerConfigKey_HeaderCompressionQuality @"HeaderCompressionQuality"
#define ServerConfigKey_DefaultTarbarIdx @"DefaultTarbarIdx"

NS_ASSUME_NONNULL_BEGIN



//*******************UpdateInfo********************//



/*
 * 更新信息
 */
@interface UpdateInfo : NSObject

/*
 * 更新标题
 */
@property(nonatomic,copy) NSString *title;

/*
 * 最新版本
 */
@property(nonatomic,copy) NSString *latestVersion;

/*
 * 更新内容
 */
@property(nonatomic,copy) NSString *updateContent;

/*
 * 更新地址
 */
@property(nonatomic,copy) NSString *updateAdress;

/*
 * 本次更新是否可以跳过
 */
@property(nonatomic,assign) BOOL canSkip;

/*
 * 是否是一个有效的更新信息
 */
@property(nonatomic,assign,readonly,getter=isValid) BOOL valid;

@end



//*******************ServerInfo********************//



/*
 * 服务器信息
 */
@interface ServerInfo : NSObject

/*
 * 启动界面延时时间
 */
@property(nonatomic,assign) NSInteger launchDelay;

/*
 * 服务器地址,用来初始化网络请求
 */
@property(nonatomic,copy) NSString *serverUrl;

/*
 * 资源地址
 */
@property(nonatomic,copy) NSString *resUrl;

/**
 * 头像资源地址
 */
@property(nonatomic,copy) NSString *headerUrl;

/*
 * 用户服务协议地址
 */
@property(nonatomic,copy) NSString *serviceAgreementUrl;

/*
 * 隐私政策地址
 */
@property(nonatomic,copy) NSString *privacyPolicyUrl;

@end



//*******************JXMainStatusManager********************//



@interface JXMainStatusManager : NSObject

@property(nonatomic,copy,readonly) NSString *respMsg;
@property(nonatomic,assign,readonly,getter=isValid) BOOL valid;

@property(nonatomic,strong,readonly) UpdateInfo *updateInfo;
@property(nonatomic,strong,readonly) ServerInfo *serverInfo;

JXSingleton_Declare(JXMainStatusManager)

/*
 * 是否有某个键的配置
 */
-(BOOL) haveConfigOfKey:(NSString *)key;

/*
 * 根据键取值，若不存在返回传入的默认值
 */
-(nullable NSString *) stringValueByKey:(NSString *)key withDefaultValue:(nullable NSString *)defaultValue;

/*
 * 根据键取值，若不存在返回nil
 */
-(nullable NSString *) stringValueByKey:(NSString *)key;

/*
 * 根据键取值，若不存在返回传入的默认值
 */
-(NSInteger) intValueByKey:(NSString *)key withDefaultValue:(NSInteger)defaultValue;

/*
 * 根据键取值，若不存在返回0
 */
-(NSInteger) intValueByKey:(NSString *)key;

/*
 * 根据键取值，若不存在返回传入的默认值
 */
-(Float32) floatValueByKey:(NSString *)key withDefaultValue:(Float32)defaultValue;

/*
 * 根据键取值，若不存在返回0.0f
 */
-(Float32) floatValueByKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
