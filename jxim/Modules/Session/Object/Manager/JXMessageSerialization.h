//
//  JXMessageSerialization.h
//  NIM
//
//  Created by Netease on 2019/10/16.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@class JXMessageSerializationInfo;

typedef void(^JXMessageEncodeResult)(NSError * _Nullable error, JXMessageSerializationInfo * _Nullable info);
typedef void(^JXMessageDecodeResult)(NSError * _Nullable error, NSMutableArray<NIMMessage *> * _Nullable messages);

@interface JXMessageSerialization : NSObject

- (void)encode:(NSArray <NIMMessage *>*)messages
       encrypt:(BOOL)encrypt
      password:(NSString *)password
    completion:(JXMessageEncodeResult)completion;

- (void)decode:(NSString *)filePath
       encrypt:(BOOL)encrypt
      password:(NSString *)password
    completion:(JXMessageDecodeResult)completion;

@end

@interface JXMessageSerializationInfo : NSObject

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, copy) NSString *md5;

@property (nonatomic, assign) BOOL encrypted;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, assign) BOOL compressed;

@end

NS_ASSUME_NONNULL_END
