//
//  MoreMenuItem.h
//  jxim
//
//  Created by yangfantao on 2020/3/23.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MoreMneuType) {
    MoreMneuTypeAddFriend = 0,
    MoreMneuTypeGroupChat,
    MoreMneuTypeScan,
    MoreMneuTypeHelp
};

@interface MoreMenuItem : NSObject

/*
 * 类型
 */
@property (nonatomic, assign) MoreMneuType type;

/*
 * 标题
 */
@property (nonatomic, strong) NSString *title;

/*
 * 图标
 */
@property (nonatomic, strong) NSString *iconPath;

/*
 * 对应的控制器
 */
@property (nonatomic, strong) NSString *className;

+ (MoreMenuItem *)createWithType:(MoreMneuType)type
                           title:(NSString *)title
                        iconPath:(NSString *)iconPath
                       className:(NSString *)className;


@end

NS_ASSUME_NONNULL_END
