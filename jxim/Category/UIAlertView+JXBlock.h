//
//  UIAlertView+JXBlock.h
//

#import <UIKit/UIKit.h>
typedef void (^AlertBlock)(NSInteger);
NS_ASSUME_NONNULL_BEGIN
@interface UIAlertView (JXBlock)
- (void)showAlertWithCompletionHandler: (__nullable AlertBlock)block;
- (void)clearActionBlock;
@end



@interface UIAlertController (JXBlock)
- (UIAlertController *)addAction:(NSString *)title
                           style:(UIAlertActionStyle)style
                         handler:(void (^ __nullable)(UIAlertAction *action))handler;

- (void)show;
@end
NS_ASSUME_NONNULL_END
