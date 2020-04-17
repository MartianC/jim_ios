//
//  JXContactGroupData.m
//  jxim
//
//  Created by yangfantao on 2020/3/27.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXContactGroupData.h"

@interface JXContactGroupData()

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSMutableArray<JXContactMemberData *> *members;
@property(nonatomic,assign) JXContactGroupType groupType;

@end

@implementation JXContactGroupData

-(instancetype) initWithTitle:(NSString *)title groupTpe:(JXContactGroupType)group
{
    if (self = [super init]) {
        _title = title;
        _groupType = group;
        _members = [[NSMutableArray<JXContactMemberData *> alloc] init];
    }
    return self;
}

-(JXContactGroupType)groupType
{
    return _groupType;
}

-(void)addMember:(JXContactMemberData *)member sortMember:(BOOL)sort
{
    if (member) {
        [_members addObject:member];
        if (sort) {
            [self sortMember];
        }
    }
}

-(void)addMembers:(NSArray<JXContactMemberData *> *)members sortMembers:(BOOL)sort
{
    if (members && members.count > 0) {
        [_members addObjectsFromArray:members];
        if (sort) {
            [self sortMember];
        }
    }
}

-(void)sortMember
{
    if (_members.count < 1) return;
    [_members sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [((JXContactMemberData *)obj1).sortValue compare:((JXContactMemberData *)obj2).sortValue];
    }];
}

-(nullable JXContactMemberData *)memberAtIndex:(NSInteger)index
{
    if (!_members || index >= _members.count) {
        return nil;
    }
    return [_members objectAtIndex:index];
}

-(NSInteger)memberNum
{
    if (!_members) {
        return 0;
    }
    return _members.count;
}

-(NSString *)title
{
    return _title;
}

@end
