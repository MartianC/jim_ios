//
//  JXTableData.m
//  jxim
//
//  Created by Xueyue Liu on 2020/3/30.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXCommonTableData.h"
#import "JXMineDef.h"

@implementation JXCommonTableSection

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super initWithDict:dict];
    if (self) {
        self.headerTitle = dict[HeaderTitle];
        self.footerTitle = dict[FooterTitle];
        self.uiFooterHeight = [dict[FooterHeight] floatValue];
        self.uiHeaderHeight = [dict[HeaderHeight] floatValue];
        self.uiHeaderHeight = self.uiHeaderHeight ? self.uiHeaderHeight : JXUIHeaderHeight;
        self.uiFooterHeight = self.uiFooterHeight ? self.uiFooterHeight : JXUIFooterHeight;
        self.rows = [JXCommonTableRow rowsWithData:dict[RowContent]];
    }
    return self;
}

+ (NSArray *)sectionsWithData:(NSArray *)data{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:data.count];
    for (NSDictionary *dict in data) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            JXCommonTableSection * section = [[JXCommonTableSection alloc] initWithDict:dict];
            if (section) {
                [array addObject:section];
            }
        }
    }
    return array;
}

@end

@implementation JXCommonTableRow

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super initWithDict:dict];
    
    if (self) {
        self.icon = dict[Icon];
        self.showRedDot = [dict[ShowRedDot] boolValue];
        self.showBottomLine = [dict[ShowBottomLine] boolValue];
        self.uiRowHeight = dict[RowHeight] ? [dict[RowHeight] floatValue] : JXUIRowHeight;
        self.accessoryType = [dict[AccessoryType] intValue];
        self.forbidSelect = [dict[ForbidSelect] boolValue] || [dict[AccessoryType] intValue] == AccessoryType_Switch;
    }
    return self;
}

+ (NSArray *)rowsWithData:(NSArray *)data{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:data.count];
    for (NSDictionary *dict in data) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            JXCommonTableRow * row = [[JXCommonTableRow alloc] initWithDict:dict];
            if (row) {
                [array addObject:row];
            }
        }
    }
    return array;
}

@end
