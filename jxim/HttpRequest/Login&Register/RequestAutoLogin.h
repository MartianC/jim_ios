//
//  RequestAutoLogin.h
//  jxim
//
//  Created by yangfantao on 2020/4/8.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"
#import "JIMAccount.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestAutoLogin : JXHttpRequestBase

-(instancetype)initWithJimId:(NSString *)jimId;
-(JIMAccount *)jimAccount;

@end

NS_ASSUME_NONNULL_END
