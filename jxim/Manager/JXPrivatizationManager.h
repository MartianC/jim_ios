//
//  JXPrivatizationManager.h
//  jxim
//
//  Created by yangfantao on 2020/4/9.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXPrivatizationManager : NSObject

+ (instancetype)sharedInstance;
- (void)setupPrivatization;

@end

NS_ASSUME_NONNULL_END
