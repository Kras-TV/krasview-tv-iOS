//
//  TouchView.h
//  animation
//
//  Created by Аня Кайгородова on 23.04.14.
//  Copyright (c) 2014 Аня Кайгородова. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchView : UIView{
    IBOutlet UIView *strechView;
     IBOutlet UIView *strechView1;
    NSTimer* oldTimer;
}

-(void)hide;
-(void)show;

@end
