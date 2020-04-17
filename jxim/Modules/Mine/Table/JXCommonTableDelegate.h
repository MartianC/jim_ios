//
//  JXCommonTableDelegate.h
//  jxim
//
//  Created by Xueyue Liu on 2020/3/31.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXCommonTableDelegate : NSObject<UITableViewDataSource,UITableViewDelegate>

- (instancetype) initWithTableData:(NSArray *(^)(void))data;

@property (nonatomic,assign) CGFloat defaultSeparatorLeftEdge;

@end

NS_ASSUME_NONNULL_END
