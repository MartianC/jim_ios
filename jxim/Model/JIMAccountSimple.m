//
//  JIMAccountSimple.m
//  jxim
//
//  Created by yangfantao on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JIMAccountSimple.h"
#import "NSDictionary+DictionaryExt.h"
#import "NSString+StringExt.h"

@implementation JIMAccountSimple


+(instancetype)unarchiveObjectWithDictionary:(NSDictionary *)dict
{
    if (!dict || dict.count < 1) {
        return nil;
    }
    
    JIMAccountSimple *account = [[JIMAccountSimple alloc] init];
    
    account.jim_uniqueid = [dict stringValueOfKey:@"jim_uniqueid"];
    account.jim_account = [dict stringValueOfKey:@"jim_account"];
    account.jim_phone = [dict stringValueOfKey:@"jim_phone"];
    account.jim_nickname = [dict stringValueOfKey:@"jim_nickname"];
    account.jim_header = [dict stringValueOfKey:@"jim_header"];
    account.jim_gender = [dict integerValueOfKey:@"jim_gender"];
    account.nim_accid = [dict stringValueOfKey:@"nim_accid"];

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
    _jim_nickname = @"";
    _jim_header = @"";
    _jim_gender = 0;
    
    _nim_accid = @"";
}

-(BOOL)isValid
{
    if ([NSString isNulOrEmpty:_jim_uniqueid] || [NSString isNulOrEmpty:_jim_phone] || [NSString isNulOrEmpty:_nim_accid]) {
        return NO;
    }
    return YES;
}

@end
