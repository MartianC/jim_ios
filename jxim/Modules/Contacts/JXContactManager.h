//
//  JXContactManager.h
//  jxim
//
//  Created by yangfantao on 2020/3/26.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXIMGlobalDef.h"
#import "JXContactDef.h"
#import "JXContactGroupData.h"

NS_ASSUME_NONNULL_BEGIN

//
//=============================
//

@interface JXContactManager : NSObject

@property(nonatomic,assign,readonly) NSInteger groupCount;

JXSingleton_Declare(JXContactManager)

- (void)loadContact;
- (NSInteger)nimUserCount;
- (NSInteger)memberCountInGroup:(NSInteger)groupIdx;
- (NSInteger)countOfGroup;
- (NSInteger)groupIdxOfTtitle:(NSString *)title;
- (NSString *)titleOfGroup:(NSInteger)groupIdx;
- (id<JXContactDataUniProtocol>)contactDataUniProtocolOfIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
