//
//  AuthControllerDelegate.h
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 16.03.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AuthControllerDelegate <NSObject>

- (NSString *)authCtrlGetLogin;
- (NSString *)authCtrlGetPass;

@end
