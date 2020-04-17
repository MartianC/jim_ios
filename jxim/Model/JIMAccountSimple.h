//
//  JIMAccountSimple.h
//  jxim
//
//  Created by yangfantao on 2020/4/16.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JIMAccountSimple : NSObject

@property(nonatomic,copy) NSString *jim_uniqueid;
@property(nonatomic,copy) NSString *jim_account;
@property(nonatomic,copy) NSString *jim_phone;
@property(nonatomic,copy) NSString *jim_nickname;
@property(nonatomic,copy) NSString *jim_header;
@property(nonatomic,assign) NSInteger jim_gender;
@property(nonatomic,copy) NSString *nim_accid;

@property(nonatomic,assign,readonly,getter=isValid) BOOL valid;

+(instancetype)unarchiveObjectWithDictionary:(NSDictionary *)dict;

-(void) clean;

@end

NS_ASSUME_NONNULL_END
