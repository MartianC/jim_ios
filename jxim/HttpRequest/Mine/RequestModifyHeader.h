//
//  RequestModifyHeader.h
//  jxim
//
//  Created by Xueyue Liu on 2020/4/13.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestModifyHeader : JXHttpRequestBase

-(instancetype)initWithJimId:(NSString *)jimId Header:(NSString *)header;

@end

NS_ASSUME_NONNULL_END
