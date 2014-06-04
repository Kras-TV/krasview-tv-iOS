//
//  CustomNavController.m
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 04.04.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import "CustomNavController.h"
#import "VDLViewController.h"

@interface CustomNavController ()

@end

@implementation CustomNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([self.topViewController isMemberOfClass:[VDLViewController class]]){
         return UIInterfaceOrientationMaskAll;
    }else{
       return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end
