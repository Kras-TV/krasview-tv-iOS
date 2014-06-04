//
//  TouchView.m
//  animation
//
//  Created by Аня Кайгородова on 23.04.14.
//  Copyright (c) 2014 Аня Кайгородова. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
        [self show];
}

-(void)show{
    
    NSLog(@"show");
    
    [UIView beginAnimations:@"MoveAndStrech" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    strechView.alpha = 0.5;
    strechView1.alpha = 0.5;
        
    [UIView commitAnimations];
    
    
    if (oldTimer) {
        [oldTimer invalidate];
        oldTimer = nil;
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hide) userInfo:nil repeats:NO];
    oldTimer = timer;
   // [timer fire];
}

-(void)hide{
    if (oldTimer) {
        [oldTimer invalidate];
        oldTimer = nil;
    }
    
    [UIView beginAnimations:@"MoveAndStrech" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    strechView.alpha = 0.0;
    strechView1.alpha = 0.0;
    
    [UIView commitAnimations];


}

@end
