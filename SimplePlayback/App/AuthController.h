//
//  AuthController.h
//  Vitamio-Demo
//
//  Created by Аня Кайгородова on 15.03.14.
//

#import <UIKit/UIKit.h>

@interface AuthController : UIViewController

-(IBAction)auth:(id)sender;

@property (nonatomic, retain) IBOutlet UITextField* loginTextField;
@property (nonatomic, retain) IBOutlet UITextField* passwordTextField;

@property (nonatomic, retain) NSMutableData* responseData;

@end

