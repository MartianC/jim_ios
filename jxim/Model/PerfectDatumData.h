//
//  PerfectDatumData.h
//  jxim
//
//  Created by yangfantao on 2020/4/7.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PerfectDatumData : NSObject

@property(nonatomic,copy) NSString *jimId;
@property(nonatomic,copy) NSString *header;
@property(nonatomic,copy) NSString *token;
@property(nonatomic,assign,getter=isValid) BOOL valid;

@end

NS_ASSUME_NONNULL_END
