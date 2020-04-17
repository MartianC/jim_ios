//
//  RequestPerfectDatum.h
//  jxim
//
//  Created by yangfantao on 2020/4/3.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"
#import "JIMAccount.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestPerfectDatum : JXHttpRequestBase

-(instancetype)initWithJimId:(NSString *)jimId Header:(NSString *)header NickName:(NSString *)nickName Gender:(NSUInteger)gener;
-(JIMAccount *)successData;

@end

NS_ASSUME_NONNULL_END
