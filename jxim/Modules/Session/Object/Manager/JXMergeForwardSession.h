//
//  JXMergeForwardSession.h
//  NIM
//
//  Created by Netease on 2019/10/16.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JXMergeForwardProcess)(CGFloat process);
typedef void(^JXMergeForwardResult)(NSError * _Nonnull error, NIMMessage * _Nonnull message);


@interface JXMergeForwardTask : NSObject

- (void)resume;

@end

@interface JXMergeForwardSession : NSObject

- (JXMergeForwardTask *)forwardTaskWithMessages:(NSMutableArray <NIMMessage *> *)messages
                                          process:(_Nullable JXMergeForwardProcess)process
                                       completion:(_Nullable JXMergeForwardResult)completion;

@end

NS_ASSUME_NONNULL_END
