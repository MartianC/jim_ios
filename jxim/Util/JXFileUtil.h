//
//  JXFileUtil.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXFileUtil : NSObject

+ (NSString *)fileMD5:(NSString *)filepath;

+ (void)fileMD5:(NSString *)filepath completion:(void(^)(NSString *MD5))completion;

@end

NS_ASSUME_NONNULL_END
