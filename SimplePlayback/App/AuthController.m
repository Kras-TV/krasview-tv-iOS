//
//  AuthController.m
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 15.03.14.
//  Copyright (c) 2014 yixia. All rights reserved.
//

#import "AuthController.h"

@interface AuthController ()

@end

@implementation AuthController

@synthesize responseData;

#pragma makr - Life Cycle

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
    self.passwordTextField.secureTextEntry = YES;
    self.responseData = [NSMutableData new];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.loginTextField release];
    [self.passwordTextField release];
    
    [self.responseData release];
    
    [super dealloc];
}

#pragma mark - Buttons Action

-(IBAction)auth:(id)sender{
    NSMutableString* urlString = [NSMutableString stringWithFormat:@"http://tv.kraslan.ru/api/auth?login=%@&password=%@", self.loginTextField.text , self.passwordTextField.text];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@", urlString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)start{
	/*ViewController *viewCtrl;
	viewCtrl = [[[ViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    viewCtrl.delegate = self;
	[self presentModalViewController:viewCtrl animated:YES];*/
    [self saveLoginAndPassword];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil userInfo:nil];
    }];
}

-(void)saveLoginAndPassword{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.loginTextField.text forKey:@"login"];
    [userDefaults setObject:self.passwordTextField.text forKey:@"password"];
    [userDefaults synchronize];
}

#pragma mark - NSURLConnectionDelegate

-(void) showAuthError{
    NSLog(@"Неверный логин и пароль");
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Неверный логин или пароль" message:@"Попробуйте снова" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSString* result = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    if([result isEqualToString: @"auth failed"]){
        [self showAuthError];
    }else{
        NSLog(@"Получено:%@", result);
        [self start];
    }
    [result release];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Невозможно подключиться" message:@"Проверьте подключение, попробуйте еще раз" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

#pragma mark - AuthControllerDelegate

- (NSString *)authCtrlGetLogin{
    return self.loginTextField.text;
};
- (NSString *)authCtrlGetPass{
    return self.passwordTextField.text;
};

@end
