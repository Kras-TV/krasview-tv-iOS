//
//  AuthStorage.m
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 17.03.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import "AuthStorage.h"

@implementation AuthStorage

- (NSString *)authCtrlGetLogin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *result = [userDefaults objectForKey:@"login"];
    if ([result length]) {
        return result;
    } else {
        return @"";
    }
};

- (NSString *)authCtrlGetPass{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *result = [userDefaults objectForKey:@"password"];
    if ([result length]) {
        return result;
    } else {
        return @"";
    }};

@end
