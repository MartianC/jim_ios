//
//  RegisterSMSCodeData.m
//  jxim
//
//  Created by yangfantao on 2020/4/7.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "RegisterSMSCodeData.h"

@implementation RegisterSMSCodeData

-(instancetype)init
{
    if (self = [super init]) {
        _codeId = @"";
        _code = @"";
    }
    return self;
}

-(BOOL)isValid
{
    if (!_codeId || !_code || _codeId.length < 1 || _code.length < 1) {
        return NO;
    }
    return YES;
}

@end
