//
//  RequestModifyLoginPwd.h
//  jxim
//
//  Created by Xueyue Liu on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestModifyLoginPwd : JXHttpRequestBase

-(instancetype)initWithJimId:(NSString *)jimId OldPwd:(NSString *)oldPwd NewPwd:(NSString *)newPwd;

@end

NS_ASSUME_NONNULL_END
