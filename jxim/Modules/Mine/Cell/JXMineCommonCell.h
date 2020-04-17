//
//  JXMineCommonCell.h
//  jxim
//
//  Created by Xueyue Liu on 2020/3/31.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCommonTableData.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXMineCommonCell : UITableViewCell

- (void)refreshData:(JXCommonTableRow *)rowData tableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
