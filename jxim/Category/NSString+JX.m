//
//  NSString+JX.m
//

#import "NSString+JX.h"
#import <CommonCrypto/CommonDigest.h>
#import <NIMSDK/NIMSDK.h>


@implementation NSString (JX)

- (CGSize)stringSizeWithFont:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (NSString *)MD5String {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


- (NSUInteger)getBytesLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self lengthOfBytesUsingEncoding:enc];
}


- (NSString *)stringByDeletingPictureResolution{
    NSString *doubleResolution  = @"@2x";
    NSString *tribleResolution = @"@3x";
    NSString *fileName = self.stringByDeletingPathExtension;
    NSString *res = [self copy];
    if ([fileName hasSuffix:doubleResolution] || [fileName hasSuffix:tribleResolution]) {
        res = [fileName substringToIndex:fileName.length - 3];
        if (self.pathExtension.length) {
           res = [res stringByAppendingPathExtension:self.pathExtension];
        }
    }
    return res;
}

- (NSString *)tokenByPassword
{
    return [[NIMSDK sharedSDK] isUsingDemoAppKey] ? [self MD5String] : self;
}

- (NSString *)JX_localized {
    return NSLocalizedString(self, nil);
}

+ (NSString *)randomStringWithLength:(NSUInteger)length {
    if (length == 0) {
        return @"";
    }
    NSString *ret = @"";
    while (ret.length < length) {
        NSString *append = @(arc4random()).stringValue;
        ret = [ret stringByAppendingString:append];
    }
    ret = [ret substringToIndex:length];
    
    return ret;
}

@end
