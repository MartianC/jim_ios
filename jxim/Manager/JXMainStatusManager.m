//
//  JXMainStatusManager.m
//  jxim
//
//  Created by yangfantao on 2020/3/21.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXMainStatusManager.h"



//*******************UpdateInfo********************//

@implementation UpdateInfo

-(instancetype)init
{
    if (self = [super init]) {
        _title = @"";
        _latestVersion = @"";
        _updateContent = @"";
        _updateAdress = @"";
        _canSkip = YES;
    }
    return self;
}

-(BOOL) isValid
{
    if (![NSString isNulOrEmpty:_updateContent] && ![NSString isNulOrEmpty:_updateAdress] && ![NSString isNulOrEmpty:_latestVersion]) {
        return YES;
    }
    
    return NO;
}

-(NSString *)title
{
    if ([NSString isNulOrEmpty:_title]) {
        return @"发现新版本";
    }
    return _title;
}

@end




//*******************ServerInfo********************//

@implementation ServerInfo

-(instancetype)init
{
    if (self = [super init]) {
        _serverUrl = @"";
        _resUrl = @"";
        _headerUrl = @"";
        _serviceAgreementUrl = @"";
        _privacyPolicyUrl = @"";
        _launchDelay = 0.0f;
    }
    return self;
}

-(NSString *)serverUrl
{
    if ([NSString isNulOrEmpty:_serverUrl]) {
        return @"http://jimcommonwebapi.yyd6.com";
    }
    return _serverUrl;
}

@end




//*******************JXMainStatusManager********************//

@implementation JXMainStatusManager

/*
 * 服务器配置数据
 */
NSMutableDictionary<NSString *,NSString *> *_serverConfig;

/*
 * 响应状态
 */
NSInteger _respStatus;


JXSingleton_Impl(JXMainStatusManager)

-(instancetype)init
{
    if (self = [super init]) {
        [self loadMainStatusData];
    }
    return self;
}

-(void)loadMainStatusData
{
    _respStatus = -1;
    _respMsg=@"网络请求错误,请重新尝试";
    
    _updateInfo = [[UpdateInfo alloc] init];
    _serverInfo = [[ServerInfo alloc] init];
    _serverConfig = nil;
    
    NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsKey_StatusData]];
    if (nil == status || status.count < 1) return;
    
    NSDictionary *resp = [status objectValueOfKey:@"resp"];
    if (nil != resp && resp.count > 0) {
        _respStatus = [[resp objectForKey:@"status"] intValue];
        _respMsg = [resp stringValueOfKey:@"msg"];
    }
    
    NSDictionary *data = [status objectValueOfKey:@"data"];
    if (nil != data && data.count > 0) {
        //update info
        NSDictionary *update = [data objectValueOfKey:@"Update"];
        if (nil != update && update.count > 0) {
            _updateInfo.title = [update stringValueOfKey:@"Title"];
            _updateInfo.latestVersion = [update stringValueOfKey:@"LatestVersion"];
            _updateInfo.updateContent = [update stringValueOfKey:@"UContent"];
            _updateInfo.updateAdress = [update stringValueOfKey:@"UAddress"];
            _updateInfo.canSkip = 0 != [[update objectForKey:@"CanSkip"] intValue];
        }
        
        //server info
        NSDictionary *serverinfo = [data objectValueOfKey:@"ServerInfo"];
        if (nil != serverinfo && serverinfo.count > 0) {
            _serverInfo.serverUrl = [serverinfo stringValueOfKey:@"ServerUrl"];
            _serverInfo.resUrl = [serverinfo stringValueOfKey:@"ResUrl"];
            _serverInfo.headerUrl = [serverinfo stringValueOfKey:@"HeaderUrl"];
            _serverInfo.serviceAgreementUrl = [serverinfo stringValueOfKey:@"ServiceAgreementUrl"];
            _serverInfo.privacyPolicyUrl = [serverinfo stringValueOfKey:@"PrivacyPolicyUrl"];
            _serverInfo.launchDelay = [[serverinfo stringValueOfKey:@"LaunchDelay"] intValue];
        }
        
        //server config
        NSArray *configAry = [data objectValueOfKey:@"Config"];
        if (nil != configAry && configAry.count > 0) {
            _serverConfig = [[NSMutableDictionary alloc] initWithCapacity:configAry.count];
            [configAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (nil != obj) {
                    NSDictionary *item = obj;
                    [_serverConfig setObject:[item stringValueOfKey:@"ConfigValue"] forKey:[item stringValueOfKey:@"ConfigKey"]];
                }
            }];
        }
    }
}

/*
 * 响应是否有效
 */
-(BOOL) isValid
{
    return 0 == _respStatus;
}

/*
 * 是否有某个键的配置
 */
-(BOOL) haveConfigOfKey:(NSString *)key
{
    if (nil == _serverConfig || _serverConfig.count < 0) {
        return NO;
    }
    return [_serverConfig.allKeys containsObject:key];
}

/*
 * 根据键取值，若不存在返回传入的默认值
 */
-(nullable NSString *) stringValueByKey:(NSString *)key withDefaultValue:(nullable NSString *)defaultValue
{
    if (nil == _serverConfig || _serverConfig.count < 0) {
        return defaultValue;
    }
    
    id value = [_serverConfig objectForKey:key];
    if (nil == value) {
        return defaultValue;
    }
    
    return [value stringValue];
}

/*
 * 根据键取值，若不存在返回nil
 */
-(nullable NSString *) stringValueByKey:(NSString *)key
{
    return [self stringValueByKey:key withDefaultValue:nil];
}

/*
 * 根据键取值，若不存在返回传入的默认值
 */
-(NSInteger) intValueByKey:(NSString *)key withDefaultValue:(NSInteger)defaultValue
{
    if (nil == _serverConfig || _serverConfig.count < 0) {
        return defaultValue;
    }
    
    id value = [_serverConfig objectForKey:key];
    if (nil == value) {
        return defaultValue;
    }
    
    return [value intValue];
}

/*
 * 根据键取值，若不存在返回0
 */
-(NSInteger) intValueByKey:(NSString *)key
{
    return [self intValueByKey:key withDefaultValue:0];
}

/*
 * 根据键取值，若不存在返回传入的默认值
 */
-(Float32) floatValueByKey:(NSString *)key withDefaultValue:(Float32)defaultValue
{
    if (nil == _serverConfig || _serverConfig.count < 0) {
        return defaultValue;
    }
    
    id value = [_serverConfig objectForKey:key];
    if (nil == value) {
        return defaultValue;
    }
    
    return [value floatValue];
}

/*
 * 根据键取值，若不存在返回0.0f
 */
-(Float32) floatValueByKey:(NSString *)key
{
    return [self floatValueByKey:key withDefaultValue:0.0f];
}

@end
