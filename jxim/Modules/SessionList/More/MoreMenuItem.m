//
//  MoreMenuItem.m
//  jxim
//
//  Created by yangfantao on 2020/3/23.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "MoreMenuItem.h"

@implementation MoreMenuItem

+ (MoreMenuItem *)createWithType:(MoreMneuType)type
                           title:(NSString *)title
                        iconPath:(NSString *)iconPath
                       className:(NSString *)className
{
    MoreMenuItem *item = [[MoreMenuItem alloc] init];
    item.type = type;
    item.title = title;
    item.iconPath = iconPath;
    item.className = className;
    return item;
}

@end
