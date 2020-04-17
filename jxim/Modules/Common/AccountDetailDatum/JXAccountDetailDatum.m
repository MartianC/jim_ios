//
//  JXAccountDetailDatum.m
//  jxim
//
//  Created by yangfantao on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "JXAccountDetailDatum.h"
#import <NIMSDK/NIMSDK.h>

@interface JXAccountDetailDatum ()

@property(nonatomic,strong) JIMAccountSimple *account;

@end

@implementation JXAccountDetailDatum

-(instancetype)initWithAccount:(JIMAccountSimple *)account
{
    if (self = [super init]) {
        _account = account;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL isFriend = [NIMSDK.sharedSDK.userManager isMyFriend:self.account.nim_accid];
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
