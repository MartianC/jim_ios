//
//  UIScrollView+JXPullToRefresh.h
//

#import <UIKit/UIKit.h>

@class JXPullToRefreshView;

@interface UIScrollView (JXPullToRefresh)

typedef NS_ENUM(NSUInteger, JXPullToRefreshPosition) {
    JXPullToRefreshPositionTop = 0,
    JXPullToRefreshPositionBottom,
};

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(JXPullToRefreshPosition)position;
- (void)triggerPullToRefresh;

@property (nonatomic, strong, readonly) JXPullToRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL showsPullToRefresh;

@end


typedef NS_ENUM(NSUInteger, JXPullToRefreshState) {
    JXPullToRefreshStateStopped = 0,
    JXPullToRefreshStateTriggered,
    JXPullToRefreshStateLoading,
    JXPullToRefreshStateAll = 10
};

@interface JXPullToRefreshView : UIView

@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;
@property (nonatomic, strong, readwrite) UIColor *activityIndicatorViewColor;
@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property (nonatomic, readonly) JXPullToRefreshState state;
@property (nonatomic, readonly) JXPullToRefreshPosition position;

- (void)setTitle:(NSString *)title forState:(JXPullToRefreshState)state;
- (void)setSubtitle:(NSString *)subtitle forState:(JXPullToRefreshState)state;
- (void)setCustomView:(UIView *)view forState:(JXPullToRefreshState)state;

- (void)startAnimating;
- (void)stopAnimating;


@end

