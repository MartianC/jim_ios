//
//  NSString+JX.h
//

#import <UIKit/UIKit.h>

@interface NSString (JX)

- (CGSize)stringSizeWithFont:(UIFont *)font;

- (NSString *)MD5String;

- (NSUInteger)getBytesLength;

- (NSString *)stringByDeletingPictureResolution;

- (NSString *)tokenByPassword;

- (NSString *)JX_localized;

+ (NSString *)randomStringWithLength:(NSUInteger)length;

@end
