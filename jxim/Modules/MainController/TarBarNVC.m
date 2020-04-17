//
//  TarBarNVC.m
//  jxim
//
//  Created by yangfantao on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "TarBarNVC.h"

@interface TarBarNVC ()

@end

@implementation TarBarNVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    NSString *ctrlName = NSStringFromClass([viewController class]);
    
    if ([ctrlName isEqualToString:@"JXSessionListVC"] ||
        [ctrlName isEqualToString:@"JXContactsVC"] ||
        [ctrlName isEqualToString:@"JXYouLiaoVC"] ||
        [ctrlName isEqualToString:@"JXMineVC"]) {
        
        viewController.hidesBottomBarWhenPushed = NO;

    }else{
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
