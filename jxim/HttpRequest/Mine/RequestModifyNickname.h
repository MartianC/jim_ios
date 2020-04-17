//
//  RequestModifyNickname.h
//  jxim
//
//  Created by Xueyue Liu on 2020/4/14.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestModifyNickname : JXHttpRequestBase

-(instancetype)initWithJimId:(NSString *)jimId Nickname:(NSString *)nickname;

@end

NS_ASSUME_NONNULL_END
