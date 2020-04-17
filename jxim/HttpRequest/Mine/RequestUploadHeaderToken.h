//
//  RequestUploadHeaderToken.h
//  jxim
//
//  Created by Xueyue Liu on 2020/4/13.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"
#import "PerfectDatumData.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestUploadHeaderToken : JXHttpRequestBase

-(instancetype)initWithJimId:(NSString *)jimId;
-(PerfectDatumData *)perfectDatumData;

@end

NS_ASSUME_NONNULL_END
