//
//  FramesPerSecondLabel.m
//  TextureExample
//
//  Created by chenghua on 2021/8/17.
//

#import "FramesPerSecondMonitor.h"

#import <UIKit/UIKit.h>

@interface FramesPerSecondMonitor ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) CFTimeInterval last;

@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, copy) void(^handler)(NSString *);

@end

@implementation FramesPerSecondMonitor

+ (instancetype)monitor {
    static FramesPerSecondMonitor *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self monitor];
}

- (instancetype)init {
    if (self = [super init]) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        if (![window.subviews containsObject:self.label]) {
            [window addSubview:self.label];
        }
        
        [self setUpNotifications];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.displayLink invalidate];
}

- (void)displayLinkTick:(CADisplayLink *)displayLink {
    _count++;
    CFTimeInterval interval = displayLink.timestamp - _last;
    if (interval < 1) return;
    _last = displayLink.timestamp;
    float fps = _count / interval;
    _count = 0;
    NSString *text = [NSString stringWithFormat:@"%d", (int)round(fps)];
    self.label.text = text;
    if (self.handler) {
        self.handler(text);
    }
}

- (void)setUpNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminateNotification) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)applicationDidBecomeActiveNotification {
    self.displayLink.paused = NO;
}

- (void)applicationWillResignActiveNotification {
    self.displayLink.paused = YES;
}

- (void)applicationWillTerminateNotification {
    self.displayLink.paused = YES;
}

- (void)openWithHandler:(void (^)(NSString * _Nonnull))handler {
    self.label.hidden = NO;
    self.displayLink.paused = NO;
    self.handler = handler;
}

- (void)open {
    [self openWithHandler:nil];
}

- (void)close {
    self.displayLink.paused = YES;
    self.label.hidden = YES;
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
        _displayLink.paused = YES;
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(100, 60, 20, 12);
        _label.backgroundColor = UIColor.redColor;
        _label.textColor = UIColor.whiteColor;
        _label.font = [UIFont systemFontOfSize:10];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
