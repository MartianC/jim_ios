//
//  RequestModifyGender.h
//  jxim
//
//  Created by Xueyue Liu on 2020/4/14.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestModifyGender : JXHttpRequestBase

-(instancetype)initWithJimId:(NSString *)jimId Gender:(NSUInteger)gender;

@end

NS_ASSUME_NONNULL_END
