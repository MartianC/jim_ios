//
//  JXMinePortraitView.h
//  jxim
//
//  Created by Xueyue Liu on 2020/4/7.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCommonTableData.h"
#import <NIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXMinePortraitView : UIView

- (void)refreshData: (nullable NIMUser *)simpleAccount;

@end

NS_ASSUME_NONNULL_END
