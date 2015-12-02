//
//  settings.m
//  RevolutionaryActs
//
//  Created by Pasumai Solutions on 26/10/15.
//  Copyright © 2015 Pasumai-Solutions Private Limited. All rights reserved.
//

#import "settings.h"
#define button_frame_change(CGRect,UIButton, float, position)  CGRect=UIButton.frame; CGRect.position=float;  UIButton.frame=CGRect

@implementation settings

-(void)viewDidLoad
{
      [super viewDidLoad];
      _push_notification_label.text=PUSHNOTIFICATION_LABEL;
      _newsletter_label.text=NEWSLETTER_LABEL;
     // _login_label.text=LOGIN_INFO_LABEL;
      
      if (LOGIN_USER)/* Authorized User have to access the newsletter switch */
      {
           // _login_label.hidden=YES;
            if ([[NSUSER objectForKey:@"news_letter"] integerValue] == 1 )
            {
                  [_newsletter_switch setOn:TRUE];
            }
            else
            {
                  [_newsletter_switch setOn:FALSE];
            }
      }
      else /*For the guest user hide newsletter */
      {
            _newsletter_label.hidden=YES;
           _newsletter_switch.hidden=YES;
          [_logout_outlet setTitle:@"Login" forState:UIControlStateNormal]; /*change the logout outlet -> login outlet for guest user while enter into the settings page */
           
            _logout_top_layout.constant=0;
      }
      
      
      /* Push notification switch is common for login and guest user as well*/
      if ([NSUSER boolForKey:@"pushnotification"])
      {
            [_push_notification_switch setOn:TRUE];
      }
      else
      {
            [_push_notification_switch setOn:FALSE];
      }
}


- (IBAction)newsletter_switch_action:(id)sender /* change newsletter switch*/
{
      if([sender isOn])
      {
            [NSUSER setObject:@"1" forKey:@"news_letter"];
            NSLog(@"Switch is ON");
      }
      else
      {
             [NSUSER setObject:@"0" forKey:@"news_letter"];
            NSLog(@"Switch is OFF");
      }
      [NSUSER synchronize];
}

- (IBAction)push_notification_switch_action:(id)sender /* change  push notification switch */
{
      /* this "pushnotification_enabled_in_device" nsuser used to if the user disable the pushnotification in the device notification center , alert before enable the switch here */
      if ([NSUSER boolForKey:@"pushnotification_enabled_in_device"])
      {
            if([sender isOn])
            {
                  [NSUSER setBool:TRUE forKey:@"pushnotification"];
                  NSLog(@"Switch is ON");
            }
            else
            {
                  [NSUSER setBool:FALSE forKey:@"pushnotification"];
                  NSLog(@"Switch is OFF");
            }
      }
      else
      {
            /* This is the alert show to the user when he disable the pushnotification in notification center */
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:TOAST_FOR_TURNON_THE_PUSHNOTIFICATION_IN_DEVICE message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            [_push_notification_switch setOn:FALSE];
      }
      [NSUSER synchronize];
}


- (IBAction)logout_action:(id)sender /* logout action */
{
      [self performSegueWithIdentifier:@"logout" sender:self];
      [self local_update_call:@"logout"]; /* before leave from this page we should call this method if the user change the switch, should update to the Installation class in parse as well user class in parse */
}

- (IBAction)exit_action:(id)sender
{
      [self local_update_call:@"exit"]; /* before leave from this page we should call this method if the user change the switch, should update to the Installation class in parse as well user class in parse */
      [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)local_update_call :(NSString *)str
{
      if ([self check_network]) /* check network */
      {
                        [self update_settings:str]; /*this method is present in the UIViewController_RevolutionaryViewController Category file */
      }
      else/*if the network is not present save the data in nsuser and when the user turn on the network connection , call this method in RevloutionaryActsViewController */
      {
                        [NSUSER setBool:TRUE forKey:@"update_settings"];
                        [NSUSER synchronize];
      }
}

@end
