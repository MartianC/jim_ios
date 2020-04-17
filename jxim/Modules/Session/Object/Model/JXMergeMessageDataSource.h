//
//  JXMergeMessageDataSource.h
//  NIM
//
//  Created by zhanggenning on 2019/10/18.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

@class JXMessageModel;
@class JXMultiRetweetAttachment;

NS_ASSUME_NONNULL_BEGIN

@interface JXMergeMessageDataSource : NSObject

@property (nonatomic, strong) NSMutableArray<JXMessageModel *> *items;

- (void)pullDataWithAttachment:(JXMultiRetweetAttachment *)attachment
                    completion:(void (^)(NSString *msg))complete;

- (NSIndexPath *)updateMessage:(NIMMessage *)message;

- (JXMessageModel *)setupMessageModel:(NIMMessage *)message;

- (NSMutableArray<JXMessageModel *> *)itemsWithMessages:(NSMutableArray <NIMMessage *> *)messages;

@end

NS_ASSUME_NONNULL_END
