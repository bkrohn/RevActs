//
//  Header.h
//  RevolutionaryActs
//
//  Created by Pasumai Solutions on 26/10/15.
//  Copyright © 2015 Pasumai-Solutions Private Limited. All rights reserved.
//
/*
 Note:
      If you want to change the Facebook ID, please change it from the info.plist
 */
#ifndef Header_h
#define Header_h
   /**  To Change the ID's here **/
#define PARSE_APPLICATION_ID @"oZ9Yjcu1T3PX5wcNXvgvRJg9qo5LUaVhIloannYl"   /** Change the Parse Application ID Here **/
#define PARSE_CLIENT_ID @"fazpxKwdIOpPlK3MEc1VGbgAF2mU5dbJrE9S9dU0"  /** Change the Parse Client ID Here **/
#define APPIRATER_ID @"469430375"      /** Change the App rater ID here **/

/* These are share url , share method present in the UIViewController+RevolutionaryViewController category file */
#define WEBSITE_URL @"https://experiencelife.com/category/grow/101-revolutionary-acts/"
#define APP_URL @"https://itunes.apple.com/us/app/101-revolutionary-ways-to/id469430375?mt=8"

/** Change Settings page text of pushnotification label, newsletter label, login information for guest user label **/
#define PUSHNOTIFICATION_LABEL @"Send me the Push Notification"
#define NEWSLETTER_LABEL @"Send me the monthly RevAct newsletter"
#define LOGIN_INFO_LABEL @"Please Login or Register to receive newsletter"


            /** you can change the Toast Messages  here **/
#define TOAST(NSString) [ALToastView toastInView:self.view withText:NSString];
#define TOAST_FOR_REQUIRED_FIELDS  TOAST(@"Please enter the required fields");
#define TOAST_FOR_CHECK_EMAIL_ID TOAST(@"Check your email-id or password");
#define TOAST_FOR_INVALID_LOGIN_CREDENTIALS TOAST(@"Invalid Login Credential");
#define TOAST_FOR_PASSWORD_MISMATCH   TOAST(@"Password mismatch");
#define TOAST_FOR_REGISTRATION_FAILED  TOAST(@"Registration Failed");
#define TOAST_FOR_REGISTRATION_SUCCESS  TOAST(@"Successfully Registered");
#define TOAST_FOR_LOGIN_SUCCESS  TOAST(@"Successfully Logged in");
#define TOAST_FOR_LOGIN_FAILED  TOAST(@"Login failed");
#define TOAST_FOR_TRY_AGAIN  TOAST(@"Please try again");
#define TOAST_FOR_INTERNET_CONNECTION TOAST(@"Check your internet Connection")
#define TOAST_FOR_VALID_EMAIL_ADDRESS  TOAST(@"Please enter the valid email address")
#define TOAST_FOR_RESET_PASSWORD_SUCCESS TOAST(@"Please check your mail to reset your password");
#define TOAST_FOR_RESET_PASSWORD_FAILURE TOAST(@"No user found with email address");
#define TOAST_FOR_TURNON_THE_PUSHNOTIFICATION_IN_DEVICE @"Please manage push notification in the iOS Notifications Center."



   /** Below common macros **/
#define START_LOAD [[[Loading alloc] init] StartLoading:self.view];
#define STOP_LOAD  [[[Loading alloc] init] StopLoading];
#define NSUSER [NSUserDefaults standardUserDefaults]
#define UPDATE_SETTINGS  if ([NSUSER objectForKey:@"update_settings"] && [self check_network] && [PFUser currentUser]){ [self update_settings:@"exit"]; }
#define LOGIN_USER  [PFUser currentUser]
#define ENDEDITING [self.view endEditing:TRUE]

#define IS_LESS568 [[UIScreen mainScreen ] bounds].size.width <550
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.width - ( double )568 ) < DBL_EPSILON )
/* This Method used to know the user enable/disable the pushnotification from notification center. If disable, also disable in parse and remove some nsuser related to pushnotification */
#define CHECK_USER_DISABLE_PUSHNOTIFICATION_ON_DEVICE  [self pushnotification_on_device];

#endif