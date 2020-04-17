//
//  NTESMessageUtil.h
//  NIM
//
//  Created by Netease on 2019/10/17.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXMessageUtil : NSObject

+ (NSString *)messageContent:(NIMMessage *)message;

@end

NS_ASSUME_NONNULL_END
