//
//  UIScrollView+JXDirection.m
//

#import "UIScrollView+JXDirection.h"
#import <objc/runtime.h>


@interface UIScrollView ()
@property (assign, nonatomic) JXScrollViewDirection horizontalScrollingDirection;
@property (assign, nonatomic) JXScrollViewDirection verticalScrollingDirection;
@end


static const char horizontalScrollingDirectionKey;
static const char verticalScrollingDirectionKey;


@implementation UIScrollView (JXDirection)

- (void)startObservingDirection
{
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)stopObservingDirection
{
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![keyPath isEqualToString:@"contentOffset"]) return;
    
    CGPoint newContentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
    CGPoint oldContentOffset = [[change valueForKey:NSKeyValueChangeOldKey] CGPointValue];
    
    if (oldContentOffset.x < newContentOffset.x) {
        self.horizontalScrollingDirection = JXScrollViewDirectionRight;
    } else if (oldContentOffset.x > newContentOffset.x) {
        self.horizontalScrollingDirection = JXScrollViewDirectionLeft;
    } else {
        self.horizontalScrollingDirection = JXScrollViewDirectionNone;
    }
    
    if (oldContentOffset.y < newContentOffset.y) {
        self.verticalScrollingDirection = JXScrollViewDirectionDown;
    } else if (oldContentOffset.y > newContentOffset.y) {
        self.verticalScrollingDirection = JXScrollViewDirectionUp;
    } else {
        self.verticalScrollingDirection = JXScrollViewDirectionNone;
    }
}

#pragma mark - Properties
- (JXScrollViewDirection)horizontalScrollingDirection
{
    return [objc_getAssociatedObject(self, (void *)&horizontalScrollingDirectionKey) intValue];
}

- (void)setHorizontalScrollingDirection:(JXScrollViewDirection)horizontalScrollingDirection
{
    objc_setAssociatedObject(self, (void *)&horizontalScrollingDirectionKey, [NSNumber numberWithInt:horizontalScrollingDirection], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JXScrollViewDirection)verticalScrollingDirection
{
    return [objc_getAssociatedObject(self, (void *)&verticalScrollingDirectionKey) intValue];
}

- (void)setVerticalScrollingDirection:(JXScrollViewDirection)verticalScrollingDirection
{
    objc_setAssociatedObject(self, (void *)&verticalScrollingDirectionKey, [NSNumber numberWithInt:verticalScrollingDirection], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
