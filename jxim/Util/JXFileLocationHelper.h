//
//  JXFileLocationHelper.h
//

#import <Foundation/Foundation.h>

#define ImageExt   (@"jpg")


@interface JXFileLocationHelper : NSObject

+ (NSString *)getAppDocumentPath;

+ (NSString *)getAppTempPath;

+ (NSString *)userDirectory;

+ (NSString *)genFilenameWithExt:(NSString *)ext;

+ (NSString *)filepathForVideo:(NSString *)filename;

+ (NSString *)filepathForImage:(NSString *)filename;

+ (NSString *)filepathForMergeForwardFile:(NSString *)filename;

@end
