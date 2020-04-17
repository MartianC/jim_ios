//
//  NSString+StringExt.m
//  jxim
//
//  Created by yangfantao on 2020/3/20.
//  Copyright © 2020 jxwl. All rights reserved.
//

#import "NSString+StringExt.h"
#import <objc/runtime.h>

@implementation NSString(NSString_StringExt)

+(BOOL) isNulOrEmpty:(NSString *)str
{
    if (nil == str || 0 == str.length) {
        return YES;
    }
    return NO;
}

static char NIMKitStringJsonDictionaryAddress;
- (NSDictionary *)nimkit_jsonDict
{
    NSDictionary *dict = [objc_getAssociatedObject(self, &NIMKitStringJsonDictionaryAddress) copy];
    if (dict == nil)    //解析过一次后就缓存解析结果，避免多次解析
    {
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        dict = [NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:nil];
        if (![dict isKindOfClass:[NSDictionary class]])
        {
            dict = [NSDictionary dictionary];
        }
        objc_setAssociatedObject(self,&NIMKitStringJsonDictionaryAddress,dict,OBJC_ASSOCIATION_COPY);
    }
    return dict;
}

- (NSString *)nimkit_jsonString
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:0
                                                     error:nil];
    return data ? [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding] : nil;
}

@end
