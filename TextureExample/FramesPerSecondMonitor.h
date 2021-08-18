//
//  FramesPerSecondLabel.h
//  TextureExample
//
//  Created by chenghua on 2021/8/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FramesPerSecondMonitor : NSObject

+ (instancetype)monitor;

- (void)openWithHandler:(nullable void(^)(NSString *))handler;
- (void)open;
- (void)close;

@end

NS_ASSUME_NONNULL_END
