//
//  UIActionSheet+JXBlock.h
//

#import <UIKit/UIKit.h>
typedef void (^ActionSheetBlock)(NSInteger);

@interface UIActionSheet (JXBlock)<UIActionSheetDelegate>
- (void)showInView: (UIView *)view completionHandler: (ActionSheetBlock)block;
- (void)clearActionBlock;
@end
