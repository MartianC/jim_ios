//
//  RequestPasswordLogin.h
//  jxim
//
//  Created by yangfantao on 2020/4/7.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"
#import "JIMAccount.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestPasswordLogin : JXHttpRequestBase

-(instancetype)initWithPhone:(NSString *)phone andPwd:(NSString *)pwd;
-(JIMAccount *)successData;

@end

NS_ASSUME_NONNULL_END
