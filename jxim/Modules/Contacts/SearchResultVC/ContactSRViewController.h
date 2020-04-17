//
//  ContactSRViewController.h
//  jxim
//
//  Created by yangfantao on 2020/3/29.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactSRViewController : UIViewController<UISearchResultsUpdating,
                                                      UISearchControllerDelegate,
                                                      UITableViewDelegate,
                                                      UITableViewDataSource>

@end

NS_ASSUME_NONNULL_END
