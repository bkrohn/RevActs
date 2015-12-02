//
//  LoginVC.h
//  RevolutionaryActs
//
//  Created by Pasumai Solutions on 23/10/15.
//  Copyright © 2015 Pasumai-Solutions Private Limited. All rights reserved.
//

/***  Main Methods all defined here ***/
/*Def*/
#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController <UITextFieldDelegate>

      /** Login View Outlets and Actions **/
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UITextField *login_email_textfield;
@property (strong, nonatomic) IBOutlet UITextField *login_password_textfield;
@property (strong, nonatomic) IBOutlet UIButton *login_cancel_outlet;
@property (strong, nonatomic) IBOutlet UIButton *login_signin_outlet;
@property (strong, nonatomic) IBOutlet UIButton *forgot_password_outlet;



- (IBAction)login_register_here_action:(id)sender;
- (IBAction)login_cancel_action:(id)sender;
- (IBAction)login_signin_action:(id)sender;
- (IBAction)forgot_password:(id)sender;


      /** Register View Outlets and Actions  **/
@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (strong, nonatomic) IBOutlet UITextField *register_username_textfield;
@property (strong, nonatomic) IBOutlet UITextField *register_email_textfield;
@property (strong, nonatomic) IBOutlet UITextField *register_password_textfield;
@property (strong, nonatomic) IBOutlet UITextField *register_confirmpassword_textfield;
@property (strong, nonatomic) IBOutlet UIButton *register_cancel_outlet;
@property (strong, nonatomic) IBOutlet UIButton *register_outlet;
@property (strong, nonatomic) IBOutlet UIButton *newsletter_check_outlet;

- (IBAction)register_signin_action:(id)sender;
- (IBAction)register_action:(id)sender;
- (IBAction)register_cancel_action:(id)sender;
- (IBAction)newsletter_check_action:(id)sender;





      /** Common outlets and Actions **/
@property (strong, nonatomic) IBOutlet UIView *blurView;
@property (strong, nonatomic) IBOutlet UIButton *loginwithfb;
@property (strong, nonatomic) IBOutlet UIButton *loginwithemail;

- (IBAction)login_with_facebook:(id)sender;
- (IBAction)login_with_email:(id)sender;
- (IBAction)continue_without_login:(id)sender;

@end
