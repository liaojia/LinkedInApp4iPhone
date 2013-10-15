//
//  AppDelegate.h
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-8.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property(strong, nonatomic) UINavigationController *rootNavigationController;


@end
