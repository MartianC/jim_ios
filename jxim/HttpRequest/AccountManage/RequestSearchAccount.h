//
//  RequestSearchAccount.h
//  jxim
//
//  Created by yangfantao on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXHttpRequestBase.h"
#import "JIMAccountSimple.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestSearchAccount : JXHttpRequestBase

-(instancetype)initWithSearchContent:(NSString *)searchContent;
-(JIMAccountSimple *)account;

@end

NS_ASSUME_NONNULL_END
