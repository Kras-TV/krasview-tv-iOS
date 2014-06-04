//
//  AppDelegate.h
//  Vitamio-Demo
//
//  Created by erlz nuo on 7/8/13.
//  Copyright (c) 2013 yixia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class List;
@class AuthStorage;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) List *viewController;
@property (strong, nonatomic) UINavigationController *navController;

@property (nonatomic, retain) AuthStorage* authStorage;

@end
