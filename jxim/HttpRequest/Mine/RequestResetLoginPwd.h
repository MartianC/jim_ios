//
//  RequestResetLoginPwd.h
//  jxim
//
//  Created by Xueyue Liu on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestResetLoginPwd : JXHttpRequestBase

-(instancetype)initWithJimId:(NSString *)jimId Pwd:(NSString *)pwd Code:(NSString *)code CodeId:(NSString *)codeId;

@end

NS_ASSUME_NONNULL_END
