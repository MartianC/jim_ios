//
//  JXContactMemberData.h
//  jxim
//
//  Created by yangfantao on 2020/3/26.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXContactDef.h"
#import "NIMKitInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXContactMemberData : NSObject<NIMGroupMemberProtocol,
                                         JXContactMemberProtocol,
                                         JXContactDataSortProtocol,
                                         JXSystemContactDataProviderProtocol>

-(instancetype)initWithNimKitInfo:(nullable NIMKitInfo *)kitInfo memberType:(JXContactMemberType)type;
-(instancetype)initWithMemberType:(JXContactMemberType)type;

-(id<JXContactDataUniProtocol>) contactDataUniProtocol;

@end

NS_ASSUME_NONNULL_END
