//
//  DTShareService.m
//  ShareExample
//
//  Created by Pete Schwamb on 9/8/11.
//  Copyright 2011 Drivetrain Agency LLC. All rights reserved.
//

#import "DTShareService.h"
#import <Social/Social.h>

#define EMAIL_SHARE 0
#define FACEBOOK_SHARE 1
#define TWITTER_SHARE 2

@implementation DTShareService

@synthesize currentShareItem, currentController;


- (void)shareEmail
{
      NSLog(@"shareitem=%@",currentShareItem);
      NSLog(@"currentcontroller=%@",currentShareItem);
  if (![MFMailComposeViewController canSendMail])
  {
    UIAlertView *alert = [[UIAlertView alloc]
                           initWithTitle:@"Unable to send mail."
                           message:@"This device is not configured to send mail."
                           delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
    [alert show];
    return;
  }
  
  MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
  mailComposer.mailComposeDelegate = self;

  NSString *staticSubject = @"Healthy Wisdom From “101 Ways” Mobile App";
	[mailComposer setSubject:staticSubject];
  
  //NSString *staticBody = @"I thought you might like this health-smart tidbit I ran across while using the “101 Ways” app from Experience Life and RevolutionaryAct.com: ";
	
  // Fill out the email body text
  // NSString *body = [NSString stringWithFormat:@"%@\n%@", staticBody, currentShareItem.link];

	
  NSString *body = [NSString stringWithFormat:@"I thought you might like this health-smart article I ran across while using the “101 Ways” app from Experience Life magazine and RevolutionaryAct.com:\n\n%@\n%@\n\nP.S. Learn more about the “101 Ways” app for iPad and iPhone at http://www.experiencelife.com/app.", currentShareItem.subject, currentShareItem.link];
  
  [mailComposer setMessageBody:body isHTML:NO];
	
  [currentController presentViewController:mailComposer animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
  [currentController dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareTwitter {
  if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
    UIAlertView *alert = [[UIAlertView alloc]
                           initWithTitle:@"Unable to tweet."
                           message:@"Twitter is not configured on this device."
                           delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
    [alert show];
    return;
  }
  
  SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
  [controller addURL:[NSURL URLWithString:currentShareItem.link]];  // encode? stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding
  [controller setInitialText:[NSString stringWithFormat:@"%@ via “101 Ways” app by @ExperienceLife @RevAct", currentShareItem.subject]];
  [currentController presentViewController:controller animated:YES completion:nil];
}

- (void)shareFacebook {
  if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
    UIAlertView *alert = [[UIAlertView alloc]
                           initWithTitle:@"Unable to post."
                           message:@"Facebook is not configured on this device."
                           delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
    [alert show];
    return;
  }
  
  SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
  [controller addURL:[NSURL URLWithString:currentShareItem.link]];  // encode? stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding
  [controller setInitialText:currentShareItem.subject];
  [currentController presentViewController:controller animated:YES completion:nil];
}

- (UIActionSheet*) share:(DTShareItem*)item forController:(UIViewController*)controller {
  self.currentController = controller;
  self.currentShareItem = item;
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Share To" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                           @"Email",
                           @"Facebook",
                           @"Twitter",
                           nil];
  
  return sheet;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  switch (buttonIndex) {
    case EMAIL_SHARE:
      [self shareEmail];
      break;
    case FACEBOOK_SHARE:
      [self shareFacebook];
      break;
    case TWITTER_SHARE:
      [self shareTwitter];
      break;
    default:
      break;
  }
}

@end
