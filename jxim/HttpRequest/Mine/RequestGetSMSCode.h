//
//  RequestGetSMSCode.h
//  jxim
//
//  Created by Xueyue Liu on 2020/4/15.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"
#import "RegisterSMSCodeData.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestGetSMSCode : JXHttpRequestBase

-(instancetype)initWithJimId:(NSString *)jimId Phone:(NSString *)phone;
-(nullable RegisterSMSCodeData *)codeData;

@end

NS_ASSUME_NONNULL_END
