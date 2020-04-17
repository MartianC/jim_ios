//
//  RequestSMSLogin.h
//  jxim
//
//  Created by yangfantao on 2020/4/7.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"
#import "PerfectDatumData.h"
#import "JIMAccount.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestSMSLogin : JXHttpRequestBase

-(instancetype)initWithSMSCode:(NSString *)code CodeId:(NSString *)codeId;
-(PerfectDatumData *)perfectDatumData;
-(JIMAccount *)jimAccount;

@end

NS_ASSUME_NONNULL_END
