//
//  RegisterSMSCodeData.h
//  jxim
//
//  Created by yangfantao on 2020/4/7.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterSMSCodeData : NSObject

@property(nonatomic,copy) NSString *codeId;
@property(nonatomic,copy) NSString *code;

-(BOOL)isValid;

@end

NS_ASSUME_NONNULL_END
