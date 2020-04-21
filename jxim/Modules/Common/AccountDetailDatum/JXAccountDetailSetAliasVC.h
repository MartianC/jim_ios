//
//  JXAccountDetailSetAliasVC.h
//  jxim
//
//  Created by Xueyue Liu on 2020/4/20.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXAccountDetailSetAliasVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

-(instancetype)initWithNIMAccId:(NSString *)nimAccId;

@end

NS_ASSUME_NONNULL_END
