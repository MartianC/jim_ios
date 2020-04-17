//
//  JXSystemContactCell.h
//  jxim
//
//  Created by yangfantao on 2020/3/27.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXContactDef.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXSystemContactCell : UITableViewCell

-(void)refresh:(id<JXSystemContactDataProviderProtocol>)data;

@end

NS_ASSUME_NONNULL_END
