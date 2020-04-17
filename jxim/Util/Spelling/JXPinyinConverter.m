//
//  JXPinyinConverter.m
//

#import "JXPinyinConverter.h"


@implementation JXPinyinConverter
+ (JXPinyinConverter *)sharedInstance
{
    static JXPinyinConverter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JXPinyinConverter alloc] init];
    });
    return instance;
}


- (NSString *)toPinyin: (NSString *)source
{
    if ([source length] == 0)
    {
        return nil;
    }
    NSMutableString *piyin = [NSMutableString stringWithString:source];
    CFStringTransform((__bridge CFMutableStringRef)piyin, NULL, kCFStringTransformToLatin, false);
    
    NSString *py = [piyin stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [py stringByReplacingOccurrencesOfString:@"'" withString:@""];
}



@end
