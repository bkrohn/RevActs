//
//  UIViewController+RevolutionaryViewControllers.m
//  RevolutionaryActs
//
//  Created by Pasumai Solutions on 26/10/15.
//  Copyright © 2015 Pasumai-Solutions Private Limited. All rights reserved.
//

#import "UIViewController+RevolutionaryViewControllers.h"
#import "JBWhatsAppActivity.h"
@implementation UIViewController (RevolutionaryViewControllers)

-(BOOL)check_mail :(NSString *)email /* Return True if the user entered Email address is valid or not */
{
      BOOL isValid = NO;
      if (email.length) {
            NSString *emailStr = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            
            NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailStr];
            isValid = [test evaluateWithObject:email];
      }
      return isValid;
}

-(BOOL)equal_password :(NSString *)password confirm_password:(NSString *)confirm_password /* return true if the password and confirm password is equal */
{
      BOOL isValid = NO;
      if ([password isEqualToString:confirm_password])
      {
           isValid = TRUE;
      }
      return isValid;
}

-(NSString *)remove_whitespace:(NSString *)string_data /* Remove whitspace in the string */
{
      NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
      string_data = [string_data stringByTrimmingCharactersInSet:whitespace];
      return string_data;
}

-(BOOL)check_network /* Return yes if the network connection is available */
{
      Reachability *reachability = [Reachability reachabilityForInternetConnection];
      NetworkStatus internetStatus = [reachability currentReachabilityStatus];
      if (internetStatus != NotReachable)
      {
            return YES;
      }
      return NO;
}

-(void)update_settings :(NSString *)fromdata /* update settings page if the user change the switch */
{
      if ([PFUser currentUser]) /* Authorized user can change the newsletter switch too */
      {
      PFQuery *query = [PFQuery queryWithClassName:@"_User"];
      [query getObjectInBackgroundWithId:[PFUser currentUser].objectId block:^(PFObject *pfObj, NSError *error)
       {
             NSNumber *newslet=[NSNumber numberWithInt:[[NSUSER objectForKey:@"news_letter"] intValue]];
             [pfObj setObject:newslet forKey:@"news_letter"];
             [pfObj saveInBackground];
             [self save_user_for_pushnotification:[NSUSER boolForKey:@"pushnotification"]];
             [NSUSER removeObjectForKey:@"update_settings"];
             [NSUSER synchronize];
             if ([fromdata isEqualToString:@"logout"])
             {
                     [PFUser logOut];
             }
           
      }];
      }
      else /* Guest user only change the pushnotification flag */
      {
            [self save_user_for_pushnotification:[NSUSER boolForKey:@"pushnotification"]];
            [NSUSER removeObjectForKey:@"update_settings"];
            [NSUSER synchronize];
      }
}

-(void)sharing: (int)share_data /* Share the content in the social medias like fb, twitter, email, whatsapp */
{              /* Facebook should not allow text only url can send */
      NSString *textToShare;
      if(share_data) /* if this share data gives the actsno , by this we get title and share it */
      {
                  NSString *path = [[NSBundle mainBundle] pathForResource:@"Acts" ofType:@"plist"];
                  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
                  textToShare=[dict objectForKey:[NSString stringWithFormat:@"%i",share_data]];
      }
      else
      {
            textToShare = @"Learn about revolutionary healthy acts from 101 ways app.";
      }
      NSURL *website_url = [NSURL URLWithString:WEBSITE_URL];
      NSString *or_checkout =@"or checkout ";
      NSURL *app_url =[NSURL URLWithString:APP_URL];
      
      
      NSString *string=[NSString stringWithFormat:@"%@\n%@\n or checkout %@",textToShare,APP_URL,WEBSITE_URL];
      WhatsAppMessage *whatsappMsg = [[WhatsAppMessage alloc] initWithMessage:string forABID:APP_URL];
      
      
      NSArray *applicationActivities = @[[[JBWhatsAppActivity alloc] init]];
      
      NSArray *activityItems = [NSArray arrayWithObjects:whatsappMsg,textToShare,app_url,or_checkout,website_url, nil];
     UIActivityViewController *ActivityView = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
     
      // tell the activity view controller which activities should NOT appear
      ActivityView.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
      
      // display the options for sharing
      // ActivityView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
      
      ActivityView.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
      
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
      {
            [self presentViewController:ActivityView animated:YES completion:^{}];
      }
      //if iPad
      else
      {
            ActivityView.popoverPresentationController.sourceView = self.view;
            
            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:ActivityView];
            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height-50, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown
                                 animated:YES];
      }
}

-(void)toast_from_loginpage :(NSString *)string /* Toast after successfull login/register in the RevolutioanryActsViewController */
{
      if (string)
      {
            if ([string isEqualToString:@"login"])
            {
                  TOAST_FOR_LOGIN_SUCCESS
            }
            else if ([string isEqualToString:@"registeration"])
            {
                  TOAST_FOR_REGISTRATION_SUCCESS
            }
            else{ }
      }
}
-(void)save_user_for_pushnotification :(BOOL)value /* This method whenever the user enable/disable the pushnotification in the device notification center, trigger this method to change the same at parse */
{
      if([self check_network])
      {
      PFInstallation *installation = [PFInstallation currentInstallation];
      if (value)
      {
            installation[@"pushnotification"]=@YES;
      }
      else
      {
            installation[@"pushnotification"]=@NO;
      }
      [installation saveInBackground];
      }
}

-(void)pushnotification_on_device /* Check the push notification disable/enable in the device */
{
      if(![NSUSER boolForKey:@"pushnotification_enabled_in_device"]) /*If trunoff */
      {
            [self save_user_for_pushnotification:FALSE];
            [NSUSER setBool:FALSE forKey:@"pushnotification"]; /*Set false for pushnotification which display in settings page */
            [NSUSER removeObjectForKey:@"alreadystored"];
            [NSUSER synchronize];
      }
}


@end
