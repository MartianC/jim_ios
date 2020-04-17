//
//  NSDictionary+DictionaryExt.h
//  jxim
//
//  Created by yangfantao on 2020/3/21.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary(NSDictionary_DictionaryExt)

-(NSString *)stringValueOfKey:(NSString *)key;
-(NSInteger)integerValueOfKey:(NSString *)key;
-(nullable id)objectValueOfKey:(NSString *)key;

- (NSString *)jsonString: (NSString *)key;
- (NSDictionary *)jsonDict: (NSString *)key;
- (NSArray *)jsonArray: (NSString *)key;
- (NSArray *)jsonStringArray: (NSString *)key;
- (BOOL)jsonBool: (NSString *)key;
- (NSInteger)jsonInteger: (NSString *)key;
- (long long)jsonLongLong: (NSString *)key;
- (unsigned long long)jsonUnsignedLongLong:(NSString *)key;
- (double)jsonDouble: (NSString *)key;

@end

NS_ASSUME_NONNULL_END
