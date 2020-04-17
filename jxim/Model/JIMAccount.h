//
//  JIMAccount.h
//  jxim
//
//  Created by yangfantao on 2020/4/3.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JIMAccount : NSObject<NSCoding>

@property(nonatomic,copy) NSString *jim_uniqueid;
@property(nonatomic,copy) NSString *jim_account;
@property(nonatomic,copy) NSString *jim_phone;
@property(nonatomic,assign) NSInteger jim_status;
@property(nonatomic,copy) NSString *jim_nickname;
@property(nonatomic,copy) NSString *jim_header;
@property(nonatomic,assign) NSInteger jim_gender;
@property(nonatomic,copy) NSString *nim_accid;
@property(nonatomic,copy) NSString *nim_token;
@property(nonatomic,copy) NSString *alipay_aliid;
@property(nonatomic,copy) NSString *wechat_openid;
@property(nonatomic,assign) NSInteger status_loginpwd;

@property(nonatomic,assign,readonly,getter=isValid) BOOL valid;

+(instancetype)unarchiveObjectWithData:(NSData *)data;
+(instancetype)unarchiveObjectWithDictionary:(NSDictionary *)dict;

-(void) clean;
-(NSData *)archivedData;

@end

NS_ASSUME_NONNULL_END
