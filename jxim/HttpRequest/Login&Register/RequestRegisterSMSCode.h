//
//  RequestRegisterSMSCode.h
//  jxim
//
//  Created by yangfantao on 2020/3/30.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"
#import "RegisterSMSCodeData.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestRegisterSMSCode : JXHttpRequestBase

-(instancetype)initWithPhone:(NSString *)phone;
-(nullable RegisterSMSCodeData *)codeData;

@end

NS_ASSUME_NONNULL_END
