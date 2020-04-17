//
//  JXPerfectInfomation.h
//  jxim
//
//  Created by yangfantao on 2020/3/30.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterByPhone.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXPerfectInfomation : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

-(instancetype)initWithPerfectDatumData:(PerfectDatumData *)data;

@end

NS_ASSUME_NONNULL_END
