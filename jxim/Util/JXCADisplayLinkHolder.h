//
//  JXCADisplayLinkHolder.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JXCADisplayLinkHolder;

@protocol JXCADisplayLinkHolderDelegate <NSObject>

- (void)onDisplayLinkFire:(JXCADisplayLinkHolder *)holder
                 duration:(NSTimeInterval)duration
              displayLink:(CADisplayLink *)displayLink;

@end


@interface JXCADisplayLinkHolder : NSObject

@property (nonatomic,weak  ) id<JXCADisplayLinkHolderDelegate> delegate;
@property (nonatomic,assign) NSInteger frameInterval;

- (void)startCADisplayLinkWithDelegate: (id<JXCADisplayLinkHolderDelegate>)delegate;

- (void)stop;

@end
