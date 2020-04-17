//
//  NSData+JX.h
//

#import <Foundation/Foundation.h>

@interface NSData (JX)
- (NSString *)MD5String;

- (NSData *)aes256EncryptWithKey:(NSString *)key vector:(NSString *)vector;
- (NSData *)aes256DecryptWithKey:(NSString *)key vector:(NSString *)vector;

- (NSData *)rc4EncryptWithKey:(NSString *)key;
- (NSData *)rc4DecryptWithKey:(NSString *)key;

@end
