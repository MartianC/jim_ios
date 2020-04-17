//
//  JXMigrateHeader.m
//  NIM
//
//  Created by Netease on 2019/10/16.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JXMigrateHeader.h"
#import "NSDictionary+DictionaryExt.h"

static NSString *const kJXMigrateHeaderVersion = @"version";
static NSString *const kJXMigrateHeaderTerminal = @"terminal";
static NSString *const kJXMigrateHeaderSDKVersion = @"sdk_version";
static NSString *const kJXMigrateHeaderAPPVersion = @"app_version";
static NSString *const kJXMigrateHeaderMessageCount = @"message_count";

@implementation JXMigrateHeader


+ (instancetype)initWithDefaultConfig {
    JXMigrateHeader *ret = [[JXMigrateHeader alloc] init];
    ret.version = 0;
    ret.clientType = NIMLoginClientTypeiOS;
    ret.sdkVersion = [NIMSDK sharedSDK].sdkVersion;
    ret.appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return ret;
}

+ (instancetype)initWithRawContent:(NSData *)data {
    if (!data) {
        return nil;
    }
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (![jsonData isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSDictionary *dict = (NSDictionary *)jsonData;
    JXMigrateHeader *info = [[JXMigrateHeader alloc] init];
    info.version = [dict jsonInteger:kJXMigrateHeaderVersion];
    info.clientType = [dict jsonInteger:kJXMigrateHeaderTerminal];
    info.sdkVersion = [dict jsonString:kJXMigrateHeaderSDKVersion];
    info.appVersion = [dict jsonString:kJXMigrateHeaderAPPVersion];
    info.totalInfoCount = [dict jsonInteger:kJXMigrateHeaderMessageCount];
    return info;
}

- (nullable NSData *)toRawContent {
    
    if ([self invalid]) {
        return nil;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[kJXMigrateHeaderVersion] = @(_version);
    dic[kJXMigrateHeaderTerminal] = @(_clientType);
    dic[kJXMigrateHeaderSDKVersion] = _sdkVersion;
    dic[kJXMigrateHeaderAPPVersion] = _appVersion;
    dic[kJXMigrateHeaderMessageCount] = @(_totalInfoCount);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    return jsonData;
}

- (BOOL)invalid {
    return (_totalInfoCount == 0 ||
            _version != 0);
}

@end
