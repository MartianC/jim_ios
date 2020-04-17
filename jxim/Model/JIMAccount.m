//
//  JIMAccount.m
//  jxim
//
//  Created by yangfantao on 2020/4/3.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JIMAccount.h"
#import "NSString+StringExt.h"
#import "JXIMGlobalDef.h"

@implementation JIMAccount

+(instancetype)unarchiveObjectWithData:(NSData *)data
{
    if (!data) {
        return [[JIMAccount alloc] init];
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+(instancetype)unarchiveObjectWithDictionary:(NSDictionary *)dict
{
    if (!dict || dict.count < 1) {
        return nil;
    }
    
    JIMAccount *account = [[JIMAccount alloc] init];
    
    account.jim_uniqueid = [dict stringValueOfKey:@"jim_uniqueid"];
    account.jim_account = [dict stringValueOfKey:@"jim_account"];
    account.jim_phone = [dict stringValueOfKey:@"jim_phone"];
    account.jim_status = [dict integerValueOfKey:@"jim_status"];
    account.jim_nickname = [dict stringValueOfKey:@"jim_nickname"];
    account.jim_header = [dict stringValueOfKey:@"jim_header"];
    account.jim_gender = [dict integerValueOfKey:@"jim_gender"];
    account.nim_accid = [dict stringValueOfKey:@"nim_accid"];
    account.nim_token = [dict stringValueOfKey:@"nim_token"];
    account.alipay_aliid = [dict stringValueOfKey:@"alipay_aliid"];
    account.wechat_openid = [dict stringValueOfKey:@"wechat_openid"];
    account.status_loginpwd = [dict integerValueOfKey:@"status_loginpwd"];

    if (account.isValid) {
        return account;
    }
    
    return nil;
}

-(instancetype) init
{
    if (self = [super init]) {
        [self clean];
    }
    return self;
}

-(void) clean
{
    _jim_uniqueid = @"";
    _jim_account = @"";
    _jim_phone = @"";
    _jim_status = 0;
    _jim_nickname = @"";
    _jim_header = @"";
    _jim_gender = 0;
    
    _nim_accid = @"";
    _nim_token = @"";
    
    _alipay_aliid = @"";
    _wechat_openid = @"";
    
    _status_loginpwd = 0;
}

-(BOOL)isValid
{
    if ([NSString isNulOrEmpty:_jim_uniqueid] || [NSString isNulOrEmpty:_jim_phone] || _jim_status != JIMAccountStatusNormal) {
        return NO;
    }
    return YES;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.jim_uniqueid forKey:@"jim_uniqueid"];
    [aCoder encodeObject:self.jim_account forKey:@"jim_account"];
    [aCoder encodeObject:self.jim_phone forKey:@"jim_phone"];
    [aCoder encodeObject:self.jim_nickname forKey:@"jim_nickname"];
    [aCoder encodeObject:self.jim_header forKey:@"jim_header"];
    [aCoder encodeObject:self.nim_accid forKey:@"nim_accid"];
    [aCoder encodeObject:self.nim_token forKey:@"nim_token"];
    [aCoder encodeObject:self.alipay_aliid forKey:@"alipay_aliid"];
    [aCoder encodeObject:self.wechat_openid forKey:@"wechat_openid"];
    
    [aCoder encodeInteger:self.jim_gender forKey:@"jim_gender"];
    [aCoder encodeInteger:self.jim_status forKey:@"jim_status"];
    [aCoder encodeInteger:self.status_loginpwd forKey:@"status_loginpwd"];
}

//反归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.jim_uniqueid = [aDecoder decodeObjectForKey:@"jim_uniqueid"];
        self.jim_account = [aDecoder decodeObjectForKey:@"jim_account"];
        self.jim_phone = [aDecoder decodeObjectForKey:@"jim_phone"];
        self.jim_nickname = [aDecoder decodeObjectForKey:@"jim_nickname"];
        self.jim_header = [aDecoder decodeObjectForKey:@"jim_header"];
        self.nim_accid = [aDecoder decodeObjectForKey:@"nim_accid"];
        self.nim_token = [aDecoder decodeObjectForKey:@"nim_token"];
        self.alipay_aliid = [aDecoder decodeObjectForKey:@"alipay_aliid"];
        self.wechat_openid = [aDecoder decodeObjectForKey:@"wechat_openid"];
        
        self.jim_gender = [aDecoder decodeIntegerForKey:@"jim_gender"];
        self.jim_status = [aDecoder decodeIntegerForKey:@"jim_status"];
        self.status_loginpwd = [aDecoder decodeIntegerForKey:@"status_loginpwd"];
    }
    return self;
}

-(NSData *)archivedData
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

-(NSString *)description
{
    return [NSString stringWithFormat:
        @"\n\n\n" \
        "jim_uniqueid %@\n" \
        "jim_account %@\n" \
        "jim_phone %@\n" \
        "jim_nickname %@\n" \
        "jim_header %@\n" \
        "nim_accid %@\n" \
        "nim_token %@\n" \
        "alipay_aliid %@\n" \
        "wechat_openid %@\n" \
        "jim_gender %i \n" \
        "jim_status %i \n"
        "\n\n\n",
        self.jim_uniqueid,
        self.jim_account,
        self.jim_phone,
        self.jim_nickname,
        self.jim_header,
        self.nim_accid,
        self.nim_token,
        self.alipay_aliid,
        self.wechat_openid,
        self.jim_gender,
        self.jim_status
    ];
}

@end
