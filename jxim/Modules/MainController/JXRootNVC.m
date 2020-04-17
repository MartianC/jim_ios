//
//  JXRootNVC.m
//  jxim
//
//  Created by yangfantao on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXRootNVC.h"
#import "AppDelegate.h"

@interface JXRootNVC ()

@end

@implementation JXRootNVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"";
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        
        [self.navigationBar setHidden:YES];
        
        JXIMAppDelegate *delegete = (JXIMAppDelegate *)[UIApplication sharedApplication].delegate;
        delegete.rootNVC = self;
        delegete.rootTBC = (UITabBarController *)rootViewController;
        
    }
    return self;
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
