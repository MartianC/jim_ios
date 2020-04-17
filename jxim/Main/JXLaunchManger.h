//
//  JXLaunchManger.h
//  jxim
//
//  Created by yangfantao on 2020/3/17.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "JXIMGlobalDef.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXLaunchManger : NSObject

JXSingleton_Declare(JXLaunchManger)

-(void)launchWithWindow:(UIWindow *)window;

@end

NS_ASSUME_NONNULL_END
