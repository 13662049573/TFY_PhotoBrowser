//
//  AppDelegate.m
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import "AppDelegate.h"
#import "NavigationController.h"
#import "FirstViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // clear memory for test
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        NSLog(@"AppDelegate : clear disk is done for test");
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:FirstViewController.new];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
