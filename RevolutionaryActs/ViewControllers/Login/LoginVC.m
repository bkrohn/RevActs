//
//  LoginVC.m
//  RevolutionaryActs
//
//  Created by Pasumai Solutions on 23/10/15.
//  Copyright © 2015 Pasumai-Solutions Private Limited. All rights reserved.
//

#import "LoginVC.h"
/* Local Macros */
#define HIDE_LOGINVIEW(BOOL)  _loginView.hidden=BOOL; _login_signin_outlet.hidden=BOOL; _login_cancel_outlet.hidden=BOOL
#define HIDE_REGISTERVIEW(BOOL) _registerView.hidden=BOOL; _register_cancel_outlet.hidden=BOOL; _register_outlet.hidden=BOOL


@interface LoginVC ()

@end

@implementation LoginVC
int newsletter; /* enable/disable newsletter through this intvalue */
int keyboard_appear_disapper; /*keyboard appear/disappear tag*/
NSString *segue_string; /* used to call the splashscreen only from appdelegate otherwise not */


- (void)viewDidLoad
{
       [super viewDidLoad];
       [self var_def]; /* Initialization & decleration, call nottifications */
}
      /* ViewDidLoad Methods */
-(void)var_def
{
      newsletter=0;
      keyboard_appear_disapper=1;
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSplashScreen) name:@"appDidBecomeActive" object:nil];
}
- (void)presentSplashScreen
{
      if ([NSUSER boolForKey:@"splashscreen"])
      {
            [NSUSER removeObjectForKey:@"splashscreen"];
            [NSUSER synchronize];
            SplashscreenViewController *splashscreenViewController = [[SplashscreenViewController alloc] init];
            [self presentViewController:splashscreenViewController animated:NO completion:nil];
      }
}
      /* End of ViewDidLoad Methods */

-(void)viewWillAppear:(BOOL)animated
{
      [super viewWillAppear:YES];
       [self hide];/* during open loginpage hide some items here */
      
      /* alloc Keyboard appear/disappear notifications */
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(keyboardAppeared:)
                                                   name:UIKeyboardWillShowNotification object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(keyboardDisappeared:)
                                                   name:UIKeyboardWillHideNotification object:nil];
      
      /* This Method used to know the user enable/disable the pushnotification from notification center. If disable, also disable in parse and remove some nsuser related to pushnotification */
      [self performSelector:@selector(pushnotification_on_device)  withObject:nil afterDelay:10];

}
      /* ViewWillAppear Methods */
-(void)hide
{
      ENDEDITING;
      HIDE_LOGINVIEW(YES);
      HIDE_REGISTERVIEW(YES);
      _blurView.hidden=YES;
      _loginwithemail.hidden=NO;
      /* put tapgesture in blurview to hide keyboard */
      UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
      [self.blurView addGestureRecognizer:tapGestureRecognizer];
}
-(void)handleTapFrom :(UITapGestureRecognizer *)sender
{
      ENDEDITING;
}
      /* End of ViewWillAppear Methods */
-(void)viewWillDisappear:(BOOL)animated
{
      [super viewWillDisappear:YES];
       /* dealloc Keyboard appear/disappear notifications */
      [[NSNotificationCenter defaultCenter] removeObserver:self
                                                      name:UIKeyboardWillShowNotification
                                                    object:nil];
      [[NSNotificationCenter defaultCenter] removeObserver:self
                                                      name:UIKeyboardWillHideNotification
                                                    object:nil];
}

-(void) keyboardAppeared :(NSNotification*)notification
{
      if (keyboard_appear_disapper==1 && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
            keyboard_appear_disapper=0;
            
            [UIView beginAnimations:@"animate" context:nil];
            [UIView setAnimationDuration:0.2f];
            [UIView setAnimationBeginsFromCurrentState: YES];
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-80, self.view.frame.size.width, self.view.frame.size.height); /* Scroll up the view y->(-80) */
            [UIView commitAnimations];
      }
}

-(void) keyboardDisappeared :(NSNotification*)notification
{
      if (keyboard_appear_disapper==0 && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
            keyboard_appear_disapper=1;
            
            [UIView beginAnimations:@"animate" context:nil];
            [UIView setAnimationDuration:0.2f];
            [UIView setAnimationBeginsFromCurrentState: YES];
            
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+80, self.view.frame.size.width, self.view.frame.size.height); /* Scroll Down the View ->(+80) */
            [UIView commitAnimations];
      }
      
}


- (void)didReceiveMemoryWarning
{
      [super didReceiveMemoryWarning];
     
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
      if ([segue.identifier isEqualToString:@"login"])
      {
            RevolutionaryActsViewController *revolutionary=segue.destinationViewController;
            revolutionary.login_segue=segue_string;
      }
}



            /** Button Actions **/

- (IBAction)continue_without_login:(id)sender /* Guest user action */
{
      [PFUser logOut]; /* Just call this logout,  if user logout from settings suddenly he wants to enter(continue without login) inside something behave irregular. */
      segue_string=@"continue"; /* this segue only notify the guest user */
      [self performSegueWithIdentifier:@"login" sender:nil]; /* this leads to the RevolutionaryActsViewController */
}

      /** Sign In**/
- (IBAction)login_with_email:(id)sender /* click-> Loginview appear */
{
      [PFUser logOut];
      _login_email_textfield.text=@"";
      _login_password_textfield.text=@"";
      HIDE_LOGINVIEW(NO);
      _blurView.hidden=NO;
      _loginwithemail.hidden=YES;
      
}
- (IBAction)login_register_here_action:(id)sender/*click-> registerView appear */
{
      ENDEDITING;
      HIDE_LOGINVIEW(YES);
      HIDE_REGISTERVIEW(NO);
      _register_email_textfield.text=@"";
      _register_password_textfield.text=@"";
      _register_confirmpassword_textfield.text=@"";
      _register_username_textfield.text=@"";
}
- (IBAction)login_cancel_action:(id)sender /* Cancel action */
{
      [self hide]; /* Hide all */
      _loginwithemail.hidden=NO;
}

- (IBAction)login_signin_action:(id)sender /* click signin -> verify fields-> call parse to verify user , if authorised, direct to RevolutionaryActsViewController */
{
      ENDEDITING;
      
      if ([self remove_whitespace:_login_email_textfield.text].length>0 && [self remove_whitespace:_login_password_textfield.text].length>0) 
      {
            if (![self check_network]) /*Check network connection is available */
            {
                  TOAST_FOR_INTERNET_CONNECTION; /*Toasr if not */
            }
            else
            {
                  START_LOAD; /* Put Loading */
                  HIDE_LOGINVIEW(TRUE);
                  
                  /* PFQuery need to availbilty of user verified by their email address*/
                  PFQuery *query = [PFUser query];
                  [query whereKey:@"email" equalTo:_login_email_textfield.text];
                  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
                   {
                         if (objects.count > 0) /* if present get the username of the user */
                         {
                               
                               NSLog(@"objects=%@",objects);
                               PFObject *object = [objects objectAtIndex:0];
                               NSString *username = [object objectForKey:@"username"];
                               
                                /*Save the newsletter and pys*/
                               [NSUSER setObject:[NSString stringWithFormat:@"%@",[object objectForKey:@"news_letter"]] forKey:@"news_letter"];
                               [NSUSER synchronize];
                               
                               /*this block verify the username from the email and passsword from the textfield */
                               [PFUser logInWithUsernameInBackground:username password:_login_password_textfield.text block:^(PFUser* user, NSError* error){
                                     if (!error) /* if verified */
                                     {
                                           segue_string=@"login";
                                            STOP_LOAD;
                                           [self performSegueWithIdentifier:@"login" sender:nil]; /* Direct to RevolutionaryActsViewController */
                                     } else {
                                             STOP_LOAD;
                                           HIDE_LOGINVIEW(FALSE);
                                           TOAST_FOR_INVALID_LOGIN_CREDENTIALS;
                                     }
                               }];
                         }
                         else
                         {
                                 STOP_LOAD;
                               HIDE_LOGINVIEW(FALSE);
                                TOAST_FOR_INVALID_LOGIN_CREDENTIALS;
                         }
                       
                   }];
            }
      }
      else
      {
            
            TOAST_FOR_REQUIRED_FIELDS;
      }
}

/** Register **/
- (IBAction)register_signin_action:(id)sender /* show Regiteration View & hide loginview */
{
      ENDEDITING;
      _login_email_textfield.text=@"";
      _login_password_textfield.text=@"";
      HIDE_REGISTERVIEW(YES);
      HIDE_LOGINVIEW(NO);
}

- (IBAction)register_action:(id)sender /* Verified entered fileds-> user availability-> if success direct to RevolutionaryActsViewController */
{
      ENDEDITING;
      /* remove whitspace from fields and check its length>0 */
      if ([self remove_whitespace:_register_email_textfield.text].length>0 && [self remove_whitespace:_register_password_textfield.text].length>0 && [self remove_whitespace:_register_username_textfield.text] && [self remove_whitespace:_register_confirmpassword_textfield.text])
      {
            if ([self check_mail:_register_email_textfield.text]) /* Verify Email field */
            {
                  if ([self equal_password:_register_password_textfield.text confirm_password:_register_confirmpassword_textfield.text]) /* verify password is equal or not */
                  {
                        if (![self check_network]) /*check network connection available */
                        {
                              TOAST_FOR_INTERNET_CONNECTION;
                        }
                        else
                        {
                              START_LOAD;
                              HIDE_REGISTERVIEW(TRUE);
                              
                              /* alloc Parse user and store the parse username, password, email, newsletter from the form of register view */
                              PFUser *user = [[PFUser alloc] init];
                              user[@"username"]=_register_username_textfield.text;
                              user[@"password"]=_register_password_textfield.text;
                              user[@"email"]=_register_email_textfield.text;
                              user[@"devicetype"] =@"ios"; /* Default */
                              user[@"news_letter"]=[NSNumber numberWithInt:newsletter];
                              user[@"registertype"]=@"email"; /* Default */
                              
                              
                              [NSUSER setObject:[NSString stringWithFormat:@"%i",newsletter] forKey:@"news_letter"];
                              [NSUSER synchronize];
                             
                              [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                               {
                                     if (succeeded)
                                     {
                                           segue_string=@"registeration";
                                           TOAST_FOR_REGISTRATION_SUCCESS;
                                           [_loginView removeFromSuperview];
                                           [_registerView removeFromSuperview];
                                           [_blurView removeFromSuperview];
                                           [self performSegueWithIdentifier:@"login" sender:nil];
                                     }
                                     else
                                     {
                                           HIDE_REGISTERVIEW(FALSE);
                                           NSString *errorcode=[NSString stringWithFormat:@"%@",[error userInfo][@"error"]];
                                           TOAST(errorcode);
                                           /*NSLog(@"error=%@",[error userInfo][@"error"]);
                                            NSLog(@"code==%@",[error userInfo][@"code"]);
                                            code=202, error=username  already taken
                                            code = 203 error=email already present
                                            code==125 error=invalid email address*/
                                     }
                                     STOP_LOAD;
                               }];
                        }
                  }
                  else
                  {     TOAST_FOR_PASSWORD_MISMATCH;
                  }
            }
            else
            {     TOAST_FOR_CHECK_EMAIL_ID;
            }
      }
      else
      {     TOAST_FOR_REQUIRED_FIELDS;
      }
      
}

- (IBAction)register_cancel_action:(id)sender /* Hide the register View */
{
      [self hide];
       _loginwithemail.hidden=NO;
}

- (IBAction)newsletter_check_action:(id)sender /* newsletter check/uncheck action */
{
       ENDEDITING;
      if (newsletter)
      {
            newsletter=0;
            [_newsletter_check_outlet setImage:[UIImage imageNamed:@"unchecked_checkbox"] forState:UIControlStateNormal];
      }
      else
      {
            newsletter=1;
            [_newsletter_check_outlet setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
      }
}

- (IBAction)forgot_password:(id)sender/* forgot password action click show-> alertview */
{
      HIDE_LOGINVIEW(TRUE);
      [self alertview]; /* alertview method */
       _loginwithemail.hidden=NO;
     
}

-(void)alertview
{
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forgot Password"
                                                      message:[NSString stringWithFormat:@""]
                                                     delegate:self cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Ok", nil];
      
      [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
      [alert textFieldAtIndex:0].placeholder=@"Enter your email";
      [alert textFieldAtIndex:0].keyboardType=UIKeyboardTypeEmailAddress;
      [alert textFieldAtIndex:0].delegate = self;
      [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     
      NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
      if([title isEqualToString:@"Ok"]) /* if this ok -> verify email id -> check availablity of email at parse -> o/p*/
      {
            UITextField *textField = [alertView textFieldAtIndex:0];
            textField.placeholder=@"email id";
                  /* remove whitspace from textfield and check its length>0 */
                  if ([self remove_whitespace:textField.text].length>0 && [self check_mail:textField.text])
                  {
                        if ([self check_network]) /* check network connection is present */
                        {
                              START_LOAD;
                              /* PFQuery need to availbilty of user verified by their email address*/
                              PFQuery *query = [PFQuery queryWithClassName:@"_User"];
                              [query whereKey:@"email" equalTo:textField.text];
                              
                              [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
                              {
                                    NSLog(@"%@",error);
                                    NSLog(@"%@",objects);
                                    if (!error && [objects count]>0) /* if present */
                                    {
                                          for (PFObject *object in objects)
                                          {
                                                NSLog(@"%@", object.objectId);
                                                NSLog(@"%@",[object objectForKey:@"registertype"]);
                                                /* this reset password mail should not go for the facebook user */
                                                if ([[object objectForKey:@"registertype"] isEqualToString:@"facebook"])
                                                {
                                                      /*if it is facebook user show failure toast */
                                                      _blurView.hidden=YES;
                                                      ENDEDITING;
                                                      STOP_LOAD;
                                                      HIDE_LOGINVIEW(FALSE);
                                                       _loginwithemail.hidden=YES;
                                                      TOAST_FOR_RESET_PASSWORD_FAILURE;
                                                }
                                                else /*else,it is email user then call request block to reset email address */
                                                {
                                                      [PFUser requestPasswordResetForEmailInBackground:textField.text block:^(BOOL succeeded, NSError *error)
                                                       {
                                                             _blurView.hidden=NO;
                                                             ENDEDITING;
                                                             if (succeeded)
                                                             {
                                                                   TOAST_FOR_RESET_PASSWORD_SUCCESS;
                                                             }
                                                             else
                                                             {
                                                                   TOAST_FOR_RESET_PASSWORD_FAILURE;
                                                             }
                                                              _loginwithemail.hidden=YES;
                                                              HIDE_LOGINVIEW(FALSE);
                                                             STOP_LOAD;
                                                       }];
                                                }
                                          }
                                    }
                                    
                                    else
                                    {
                                          
                                           _loginwithemail.hidden=YES;
                                          HIDE_LOGINVIEW(FALSE);
                                          TOAST_FOR_RESET_PASSWORD_FAILURE;
                                    }
                                    STOP_LOAD;
                              }];
                        }
                        else
                        {
                               _loginwithemail.hidden=NO;
                              _blurView.hidden=YES;
                              TOAST_FOR_INTERNET_CONNECTION;
                              STOP_LOAD;
                        }
                  }
                  else
                  {
                        ENDEDITING;
                         _loginwithemail.hidden=YES;
                        TOAST_FOR_VALID_EMAIL_ADDRESS;
                         HIDE_LOGINVIEW(FALSE);
                        STOP_LOAD;
                  }
      }
      else
      {
            NSLog(@"ok");
            _blurView.hidden=YES;
            ENDEDITING;
      }
}


- (IBAction)login_with_facebook:(id)sender /* click - > if the device(ios 8) have facebook app it opens facebook app to login , otherwise opens safari browser to login */ /* Note : From IOS 9SDK apple only opens the safari browser for user privacy purpose */
{
      [PFUser logOut]; /* Not necessary just call this method */
      ENDEDITING;
      if (![self check_network]) /*check network connection */
      {
            TOAST_FOR_INTERNET_CONNECTION;
      }
      else
      {
            START_LOAD;
            /*here the nsuser need bcs after successful login from facebook the splashscreen drop the direction of the RevolutionaryActViewcontroller .. for the clarification see the Viewwillappear method*/
            [NSUSER setBool:TRUE forKey:@"facebook"];
            [NSUSER synchronize];
            NSArray *permissionsArray = @[@"public_profile", @"email"]; /* Ask the user to get these requirements */
            
            /*Asking permission block */
            [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error)
             {
                  if (!user) /* Error -> user may cancel or kill the app */
                  {
                        if (!error) {
                              STOP_LOAD;
                              NSLog(@"The user cancelled the Facebook login.");
                        } else {
                              STOP_LOAD;
                              NSLog(@"An error occurred: %@", error.localizedDescription);
                              TOAST_FOR_TRY_AGAIN;
                        }
                  }
                  else /* if user accept and go */
                  {
                        if (user.isNew) /* if User is New Store the user data in parse (Registration process )*/
                        {
                              NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                              [parameters setValue:@"email" forKey:@"fields"];
                              if ([FBSDKAccessToken currentAccessToken])
                              {
                                    /*From graph API get the email address of user */
                                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                                    {
                                           if (!error) /*if yes */
                                           {
                                                 NSLog(@"fetched user:%@", result);
                                                 PFQuery *query = [PFUser query];
                                                 /*Fetch the user from object id */
                                                 [query getObjectInBackgroundWithId:LOGIN_USER.objectId block:^(PFObject *UserInfo, NSError *error)
                                                  {
                                                       NSLog(@"fetched user:%@", UserInfo);
                                                        if (!error) /*if not occure any error */
                                                        {
                                                              /*Store below info to the Parse user */
                                                              if ([result objectForKey:@"email"])
                                                              {
                                                                [UserInfo setObject:[result objectForKey:@"email"] forKey:@"email"];
                                                              }
                                                              [UserInfo setObject:@"ios" forKey:@"devicetype"];
                                                              UserInfo[@"news_letter"]=[NSNumber numberWithInt:1];
                                                              [UserInfo setObject:@"facebook" forKey:@"registertype"];
                                                              [UserInfo saveInBackground];
                                                              /*save nsuser newsletter for settings page */
                                                              [NSUSER setObject:@"1" forKey:@"news_letter"];
                                                              [NSUSER synchronize];
                                                              STOP_LOAD;
                                                              TOAST_FOR_REGISTRATION_SUCCESS; /*Registration success toast */
                                                              segue_string=@"registeration";
                                                              [self performSegueWithIdentifier:@"login" sender:nil];
                                                        }
                                                        else
                                                        {
                                                              STOP_LOAD;
                                                              TOAST_FOR_REGISTRATION_FAILED;
                                                              // Did not find any UserStats for the current user
                                                              NSLog(@"Error: %@", error);
                                                        }
                                                  }];
                                                 STOP_LOAD;
                                                
                                           }
                                           else
                                           {
                                                 NSLog(@"error=%@",error);
                                           }
                                     }];
                                    
                              }
                              else
                              {
                                    STOP_LOAD;
                                    TOAST_FOR_TRY_AGAIN;
                              }
                        }
                        else /* the facebook user already registered their data to the parse, so here it act as login through facebook */
                        {
                              STOP_LOAD;
                              segue_string=@"login";
                               PFObject *object = [PFUser currentUser]; /* get the current user */
                              [NSUSER setObject:[object objectForKey:@"news_letter"] forKey:@"news_letter"];/*get the newsletter data from parse table */
                              [NSUSER synchronize];
                              [self performSegueWithIdentifier:@"login" sender:nil];
                        }
                  }
            }];
      }
}
                  /** End of Button Actions **/


      /* Textfield return method */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
      if ([textField isEqual:_login_email_textfield])
      {
            [textField resignFirstResponder];
            [_login_password_textfield becomeFirstResponder];
      }
      else if ([textField isEqual:_login_password_textfield])
      {
            [textField resignFirstResponder];
      }
      else if ([textField isEqual:_register_email_textfield])
      {
            [_register_username_textfield becomeFirstResponder];
      }
      else if ([textField isEqual:_register_username_textfield])
      {
            [_register_password_textfield becomeFirstResponder];
      }
      else if ([textField isEqual:_register_password_textfield])
      {
            [_register_confirmpassword_textfield becomeFirstResponder];
      }
      else
      {
            [textField resignFirstResponder];
      }
      return TRUE;
}



@end
