//
//  JXSpellingCenter.h
//  
//  用于拼音全称和简称生成查询读取的类
//

#import <Foundation/Foundation.h>

@interface SpellingUnit : NSObject<NSCoding>
@property (nonatomic,strong)    NSString *fullSpelling;
@property (nonatomic,strong)    NSString *shortSpelling;
@end

@interface JXSpellingCenter : NSObject
{
    NSMutableDictionary *_spellingCache;    //全拼，简称cache
    NSString *_filepath;
}
+ (JXSpellingCenter *)sharedCenter;
- (void)saveSpellingCache;          //写入缓存

- (SpellingUnit *)spellingForString: (NSString *)source;    //全拼，简拼 (全是小写)
- (NSString *)firstLetter: (NSString *)input;               //首字母
@end
