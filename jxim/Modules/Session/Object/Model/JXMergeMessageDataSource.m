//
//  JXMergeMessageDataSource.m
//  NIM
//
//  Created by zhanggenning on 2019/10/18.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JXMergeMessageDataSource.h"
#import "JXMessageSerialization.h"
#import "JXMessageModel.h"
#import "NIMTimestampModel.h"
#import "JXMultiRetweetAttachment.h"

@interface JXMergeMessageDataSource ()

@property (nonatomic, assign) NSInteger currentDay;
@property (nonatomic, strong) JXMessageSerialization *serialization;
@end

@implementation JXMergeMessageDataSource

- (instancetype)init {
    if (self = [super init]) {
        _serialization = [[JXMessageSerialization alloc] init];
    }
    return self;
}

- (void)pullDataWithAttachment:(JXMultiRetweetAttachment *)attachment
                    completion:(void (^)(NSString *msg))complete {
    __block NSString *msg = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    NSString *filePath = attachment.filePath;
    NSString *fileUrl = attachment.url;
    BOOL fileExist = ([fm fileExistsAtPath:filePath isDirectory:&isDir] && !isDir);
    __weak typeof(self) weakSelf = self;
    if (fileExist) {
        [weakSelf.serialization decode:filePath
                               encrypt:attachment.encrypted
                              password:attachment.password
                            completion:^(NSError * _Nullable error, NSMutableArray<NIMMessage *> * _Nullable messages) {
            if (error) {
                msg = [NSString stringWithFormat:@"%@。error:%zd",@"文件解码错误", error.code];
            }  else {
                [weakSelf checkAttachmentState:messages];
                weakSelf.items = [weakSelf itemsWithMessages:messages];
            }
            if (complete) {
                complete(msg);
            }
        }];
    } else {
        __weak typeof(self) weakSelf = self;
        [[NIMSDK sharedSDK].resourceManager download:fileUrl filepath:filePath progress:nil completion:^(NSError * _Nullable error) {
            if (error) {
                msg = [NSString stringWithFormat:@"%@。error:%zd",@"附件下载错误", error.code];
            } else {
                [weakSelf.serialization decode:filePath
                                       encrypt:attachment.encrypted
                                      password:attachment.password
                                    completion:^(NSError * _Nullable error, NSMutableArray<NIMMessage *> * _Nullable messages) {
                    if (error) {
                        msg = [NSString stringWithFormat:@"%@。error:%zd",@"文件解码错误", error.code];
                    } else {
                        [weakSelf checkAttachmentState:messages];
                        weakSelf.items = [weakSelf itemsWithMessages:messages];
                    }
                    if (complete) {
                        complete(msg);
                    }
                }];
            }
        }];
    }
}

- (NSIndexPath *)updateMessage:(NIMMessage *)message
{
    JXMessageModel *model = nil;
    NSIndexPath *indexPath = nil;
    for (id item in _items) {
        
        if (![item isKindOfClass:[JXMessageModel class]]) {
            continue;
        }
        
        JXMessageModel *modelItem = (JXMessageModel *)item;
        if ([modelItem.message.messageId isEqualToString:message.messageId]) {
            model = item;
            break;
        }
    }
    if (model)
    {
        JXMessageModel *target = [self setupMessageModel:message];
        NSInteger index = [_items indexOfObject:model];
        [_items replaceObjectAtIndex:index withObject:target];
        indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    }
    return indexPath;
}

- (JXMessageModel *)setupMessageModel:(NIMMessage *)message {
    JXMessageModel *model = [[JXMessageModel alloc] initWithMessage:message];
    model.focreShowAvatar = YES;
    model.focreShowNickName = YES;
    model.focreShowLeft = YES;
    return model;
}

- (NIMTimestampModel *)setupTimeModel:(NSTimeInterval)timestamp {
    NIMTimestampModel *ret = [[NIMTimestampModel alloc] init];
    ret.messageTime = timestamp;
    ret.height = 8.0f;
    return ret;
}

- (NSMutableArray<JXMessageModel *> *)itemsWithMessages:(NSMutableArray <NIMMessage *> *)messages {
    NSMutableArray *items = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [messages enumerateObjectsUsingBlock:^(NIMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) { //插入时间
            weakSelf.currentDay = [weakSelf getDay:obj.timestamp];
            NIMTimestampModel *timeModel = [weakSelf setupTimeModel:obj.timestamp];
            [items addObject:timeModel];
            
            JXMessageModel *msgModel = [self setupMessageModel:obj];
            [items addObject:msgModel];
        } else if ([weakSelf needInsertTimeModel:obj]){
            
            id lastMsgModel = items.lastObject;
            if ([lastMsgModel isKindOfClass:[JXMessageModel class]]) {
                JXMessageModel *model = (JXMessageModel *)lastMsgModel;
                model.hiddenSeparatorLine = YES;
            }
            
            NIMTimestampModel *timeModel = [weakSelf setupTimeModel:obj.timestamp];
            [items addObject:timeModel];
            
            JXMessageModel *msgModel = [self setupMessageModel:obj];
            [items addObject:msgModel];
        } else {
            JXMessageModel *msgModel = [self setupMessageModel:obj];
            [items addObject:msgModel];
        }
    }];
    return items;
}

- (BOOL)needInsertTimeModel:(NIMMessage *)message {
    BOOL ret = NO;
    NSInteger currentDay = [self getDay:message.timestamp];
    if (_currentDay != currentDay) {
        _currentDay = currentDay;
        ret = YES;
    }
    return ret;
}

- (NSInteger)getDay:(NSTimeInterval)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    return currentDay;
}


- (void)checkAttachmentState:(NSArray *)messages{
    NSArray *items = [NSArray arrayWithArray:messages];
    for (id item in items) {
        NIMMessage *message;
        if ([item isKindOfClass:[NIMMessage class]]) {
            message = item;
        }
        if ([item isKindOfClass:[NIMMessageModel class]]) {
            message = [(NIMMessageModel *)item message];
        }
        if (message && !message.isOutgoingMsg
            && message.attachmentDownloadState == NIMMessageAttachmentDownloadStateNeedDownload
            && message.messageType != NIMMessageTypeFile)
        {
            [[NIMSDK sharedSDK].chatManager fetchMessageAttachment:message error:nil];
        }
    }
}

@end
