//
//  NSString+StringExt.h
//  jxim
//
//  Created by yangfantao on 2020/3/20.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(NSString_StringExt)

+(BOOL) isNulOrEmpty:(NSString *)str;

- (NSDictionary *)nimkit_jsonDict;
- (NSString *)nimkit_jsonString;

@end

NS_ASSUME_NONNULL_END
