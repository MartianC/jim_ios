//
//  JXSearchContactManager.h
//  jxim
//
//  Created by yangfantao on 2020/3/30.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXIMGlobalDef.h"
#import "JXContactDef.h"
#import "JXContactMemberData.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXSearchContactManager : NSObject

@property(nonatomic,assign,readonly) NSInteger groupCount;

JXSingleton_Declare(JXSearchContactManager)

- (void)readyDataOfSearchContent:(NSString *)searchContent;
- (NSInteger)memberCountInGroup:(NSInteger)groupIdx;
- (NSInteger)countOfGroup;
- (id<JXContactDataUniProtocol>)contactDataUniProtocolOfIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
