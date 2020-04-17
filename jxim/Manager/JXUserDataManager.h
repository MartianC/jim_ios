//
//  JXUserDataManager.h
//  jxim
//
//  Created by yangfantao on 2020/3/18.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JXIMGlobalDef.h"
#import "JIMAccount.h"
#import "JXLoginData.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXUserDataManager : NSObject

@property(nonatomic,strong) JIMAccount *userData;

JXSingleton_Declare(JXUserDataManager)

-(void) cleanUseDataCache;
-(JXLoginData *)loginData;

@end

NS_ASSUME_NONNULL_END
