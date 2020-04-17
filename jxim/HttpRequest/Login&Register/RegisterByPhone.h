//
//  RegisterByPhone.h
//  jxim
//
//  Created by yangfantao on 2020/3/30.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"
#import "PerfectDatumData.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterByPhone : JXHttpRequestBase

-(instancetype)initWithSMSCode:(NSString *)code CodeId:(NSString *)codeId;
-(PerfectDatumData *)resultData;

@end

NS_ASSUME_NONNULL_END
