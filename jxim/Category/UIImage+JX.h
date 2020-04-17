//
//  UIImage+JX.h
//

#import <UIKit/UIKit.h>

@interface UIImage (JX)

+ (UIImage *)fetchImage:(NSString *)imageNameOrPath;

+ (UIImage *)fetchChartlet:(NSString *)imageName chartletId:(NSString *)chartletId;

- (UIImage *)imageForAvatarUpload;

@end
