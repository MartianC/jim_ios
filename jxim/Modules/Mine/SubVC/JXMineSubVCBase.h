//
//  JXMineSubVCBase.h
//  jxim
//
//  Created by Xueyue Liu on 2020/4/9.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCommonTableDelegate.h"
#import "JXCommonTableData.h"
#import "UIColor+ColorExt.h"
#import "TLKit.h"
#import "Masonry.h"
#import "JXMineDef.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXMineSubVCBase : UIViewController

@property(nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *data;

@property (nonatomic,strong) JXCommonTableDelegate *delegator;

- (void)loadData;
- (void)loadUI;
- (UITableView *)getTableView;
- (void)addHeaderView;
+ (BOOL)willShowRedDot;

@end

NS_ASSUME_NONNULL_END
