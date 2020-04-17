//
//  UIResponder+JXFirstResponder.h
//

#import <UIKit/UIKit.h>

@interface UIResponder (JXFirstResponder)

+ (instancetype)currentFirstResponder;

+ (instancetype)currentSecondResponder;

@end
