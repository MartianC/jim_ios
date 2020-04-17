//
//  NSDictionary+DictionaryExt.m
//  jxim
//
//  Created by yangfantao on 2020/3/21.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "NSDictionary+DictionaryExt.h"

@implementation NSDictionary(NSDictionary_DictionaryExt)

-(NSString *)stringValueOfKey:(NSString *)key
{
    if (![self.allKeys containsObject:key]) {
        return @"";
    }
    
    id value = [self objectForKey:key];
    if (nil == value) {
        return @"";
    }
    return [[NSString alloc] initWithString:value];
}

-(NSInteger)integerValueOfKey:(NSString *)key
{
    if (![self.allKeys containsObject:key]) {
        return 0;
    }
    
    id value = [self objectForKey:key];
    if (nil == value) {
        return 0;
    }
    return [value intValue];
}

-(nullable id)objectValueOfKey:(NSString *)key
{
    if (![self.allKeys containsObject:key]) {
        return nil;
    }
    
    id value = [self objectForKey:key];
    if ([NSNull null] == value) {
        return nil;
    }
    
    return value;
}


- (NSString *)jsonString: (NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]])
    {
        return object;
    }
    else if([object isKindOfClass:[NSNumber class]])
    {
        return [object stringValue];
    }
    return nil;
}

- (NSDictionary *)jsonDict: (NSString *)key
{
    id object = [self objectForKey:key];
    return [object isKindOfClass:[NSDictionary class]] ? object : nil;
}


- (NSArray *)jsonArray: (NSString *)key
{
    id object = [self objectForKey:key];
    return [object isKindOfClass:[NSArray class]] ? object : nil;

}

- (NSArray *)jsonStringArray: (NSString *)key
{
    NSArray *array = [self jsonArray:key];
    BOOL invalid = NO;
    for (id item in array)
    {
        if (![item isKindOfClass:[NSString class]])
        {
            invalid = YES;
        }
    }
    return invalid ? nil : array;
}

- (BOOL)jsonBool: (NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object boolValue];
    }
    return NO;
}

- (NSInteger)jsonInteger: (NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object integerValue];
    }
    return 0;
}

- (long long)jsonLongLong: (NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object longLongValue];
    }
    return 0;
}

- (unsigned long long)jsonUnsignedLongLong:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object unsignedLongLongValue];
    }
    return 0;
}


- (double)jsonDouble: (NSString *)key{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object doubleValue];
    }
    return 0;
}

@end
