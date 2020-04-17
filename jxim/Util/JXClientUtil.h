//
//  JXClientUtil.h
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

@interface JXClientUtil : NSObject

+ (NSString *)clientName:(NIMLoginClientType)clientType;

@end
