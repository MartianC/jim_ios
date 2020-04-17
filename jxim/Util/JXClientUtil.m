//
//  JXClientUtil.m
//

#import "JXClientUtil.h"

@implementation JXClientUtil

+ (NSString *)clientName:(NIMLoginClientType)clientType{
    switch (clientType) {
        case NIMLoginClientTypeAOS:
        case NIMLoginClientTypeiOS:
        case NIMLoginClientTypeWP:
            return @"移动";
        case NIMLoginClientTypePC:
        case NIMLoginClientTypemacOS:
            return @"电脑";
        case NIMLoginClientTypeWeb:
            return @"网页";
        default:
            return @"";
    }
}

@end
