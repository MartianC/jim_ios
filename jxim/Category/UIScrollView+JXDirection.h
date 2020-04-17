//
//  UIScrollView+JXDirection.h
//


#import <UIKit/UIKit.h>


typedef enum JXScrollViewDirection {
    JXScrollViewDirectionNone,
    JXScrollViewDirectionRight,
    JXScrollViewDirectionLeft,
    JXScrollViewDirectionUp,
    JXScrollViewDirectionDown,
} JXScrollViewDirection;


@interface UIScrollView (Direction)

- (void)startObservingDirection;
- (void)stopObservingDirection;

@property (readonly, nonatomic) JXScrollViewDirection horizontalScrollingDirection;
@property (readonly, nonatomic) JXScrollViewDirection verticalScrollingDirection;

@end
