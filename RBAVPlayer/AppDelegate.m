//
//  AppDelegate.m
//  RBAVPlayer
//
//  Created by RobertHsueh on 2020/8/25.
//  Copyright © 2020 Robert. All rights reserved.
//

#import "AppDelegate.h"
#import "RBAVPlayerVC.h"

@interface AppDelegate ()

@property (nonatomic, strong) RBAVPlayerVC *playerVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.playerVC = [[RBAVPlayerVC alloc] init];
    self.naviController = [[UINavigationController alloc] initWithRootViewController:self.playerVC];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.naviController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
