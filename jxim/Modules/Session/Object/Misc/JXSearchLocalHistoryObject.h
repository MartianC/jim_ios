//
//  JXSearchLocalHistoryObject.h
//  NIM
//
//  Created by chris on 15/7/8.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

typedef NS_ENUM(NSInteger, JXSearchLocalHistoryType){
    SearchLocalHistoryTypeEntrance,
    SearchLocalHistoryTypeContent,
};

@class JXSearchLocalHistoryObject;
@protocol JXSearchObjectRefresh <NSObject>

- (void)refresh:(JXSearchLocalHistoryObject *)object;

@end

@interface JXSearchLocalHistoryObject : NSObject

@property (nonatomic,copy)   NSString *content;

@property (nonatomic,assign) CGFloat uiHeight;

@property (nonatomic,assign) JXSearchLocalHistoryType type;

@property (nonatomic,readonly) NIMMessage *message;

- (instancetype)initWithMessage:(NIMMessage *)message;

@end
