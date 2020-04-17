//
//  JXCacheDataManager.h
//  jxim
//
//  Created by yangfantao on 2020/3/20.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXIMGlobalDef.h"
#import "NSString+StringExt.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXCacheDataManager : NSObject

@property(nonatomic,copy) NSString *loginId;

-(void) cleanLoginId;

JXSingleton_Declare(JXCacheDataManager)

@end

NS_ASSUME_NONNULL_END
