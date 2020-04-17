//
//  JXContactGroupData.h
//  jxim
//
//  Created by yangfantao on 2020/3/27.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXContactDef.h"
#import "JXContactMemberData.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXContactGroupData : NSObject

-(instancetype) initWithTitle:(NSString *)title groupTpe:(JXContactGroupType)group;
-(void)addMember:(JXContactMemberData *)member sortMember:(BOOL)sort;
-(void)addMembers:(NSArray<JXContactMemberData *> *)members sortMembers:(BOOL)sort;
-(void)sortMember;
-(nullable JXContactMemberData *)memberAtIndex:(NSInteger)index;
-(NSInteger)memberNum;
-(NSString *)title;
-(JXContactGroupType)groupType;

@end

NS_ASSUME_NONNULL_END
