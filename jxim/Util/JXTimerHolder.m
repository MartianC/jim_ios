//
//  JXTimerHolder.m
//  NIM
//
//  Created by amao on 5/16/14.
//  Copyright (c) 2014 amao. All rights reserved.
//

#import "JXTimerHolder.h"

@interface JXTimerHolder ()
{
    NSTimer *_timer;
    BOOL    _repeats;
}
- (void)onTimer: (NSTimer *)timer;
@end

@implementation JXTimerHolder

- (void)dealloc
{
    [self stopTimer];
}

- (void)startTimer: (NSTimeInterval)seconds
          delegate: (id<JXTimerHolderDelegate>)delegate
           repeats: (BOOL)repeats
{
    _timerDelegate = delegate;
    _repeats = repeats;
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                              target:self
                                            selector:@selector(onTimer:)
                                            userInfo:nil
                                             repeats:repeats];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
    _timerDelegate = nil;
}

- (void)onTimer: (NSTimer *)timer
{
    if (!_repeats)
    {
        _timer = nil;
    }
    if (_timerDelegate && [_timerDelegate respondsToSelector:@selector(onJXTimerFired:)])
    {
        [_timerDelegate onJXTimerFired:self];
    }
}

@end
