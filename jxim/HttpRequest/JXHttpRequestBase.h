//
//  JXHttpRequestBase.h
//  jxim
//
//  Created by yangfantao on 2020/3/21.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "JXIMGlobalDef.h"
#import "JXHttpRequestDef.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXHttpRequestBase : YTKRequest

@property(nonatomic,assign,readonly) NSInteger respStatus;
@property(nonatomic,copy,readonly) NSString *respMsg;
@property(nonatomic,copy,readonly) NSDictionary *respData;

@end

NS_ASSUME_NONNULL_END
