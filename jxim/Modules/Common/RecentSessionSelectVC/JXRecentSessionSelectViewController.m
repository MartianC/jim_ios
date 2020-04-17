//
//  JXRecentSessionSelectViewController.m
//  jxim
//
//  Created by yangfantao on 2020/3/25.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXRecentSessionSelectViewController.h"

@implementation RecentSessionSelectViewControllerOption

-(instancetype)init
{
    if (self = [super init]) {
        _closeButtonTitle = @"关闭";
        _canMultipleSel = NO;
        _showCreateNewChat = YES;
        _title = @"选择一个聊天";
    }
    return self;
}

@end

//
//=========================================
//

@interface JXRecentSessionSelectViewController ()


@end

@implementation JXRecentSessionSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
