//
//  AppDelegate.m
//  TextureExample
//
//  Created by chenghua on 2021/8/12.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "FramesPerSecondMonitor.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    [[FramesPerSecondMonitor monitor] open];
    
    return YES;
}


@end
