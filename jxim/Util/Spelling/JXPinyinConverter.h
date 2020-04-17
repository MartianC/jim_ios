//
//  JXPinyinConverter.h
//

#import <Foundation/Foundation.h>

@interface JXPinyinConverter : NSObject
+ (JXPinyinConverter *)sharedInstance;

- (NSString *)toPinyin: (NSString *)source;
@end
