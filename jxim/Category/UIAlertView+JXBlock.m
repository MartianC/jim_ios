//
//  UIAlertView+JXBlock.m
//

#import "UIAlertView+JXBlock.h"
#import <objc/runtime.h>

static char kUIAlertViewBlockAddress;

@implementation UIAlertView (JXBlock)
- (void)showAlertWithCompletionHandler: (void (^)(NSInteger))block
{
    self.delegate = self;
    objc_setAssociatedObject(self,&kUIAlertViewBlockAddress,block,OBJC_ASSOCIATION_COPY);
    [self show];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    AlertBlock block = objc_getAssociatedObject(self, &kUIAlertViewBlockAddress);
    if (block)
    {
        block(buttonIndex);
        objc_setAssociatedObject(self, &kUIAlertViewBlockAddress, nil, OBJC_ASSOCIATION_COPY);
    }
}

- (void)clearActionBlock
{
    self.delegate = nil;
    objc_setAssociatedObject(self, &kUIAlertViewBlockAddress, nil, OBJC_ASSOCIATION_COPY);
}

@end



@implementation UIAlertController (JXBlock)
- (UIAlertController *)addAction:(NSString *)title
                           style:(UIAlertActionStyle)style
                         handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:handler];
    [self addAction:action];
    return self;
}

- (void)show
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:self animated:YES completion:nil];
}
@end
