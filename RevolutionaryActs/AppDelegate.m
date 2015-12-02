//
//  AppDelegate.m
//  RevolutionaryActs
//
//  Created by Pasumai Solutions on 23/10/15.
//  Copyright © 2015 Pasumai-Solutions Private Limited. All rights reserved.
//

#import "AppDelegate.h"
#import "Header.h"
#import "UIViewController+RevolutionaryViewControllers.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
      [self NSUSER_Method]; /* nsuser set and remove keys*/
      [self PARSE_Method:launchOptions]; /* Call parse and luanch parsefacebookutilities */
      [self COOKIES];
      [self APPIRATER]; /** Rate the App function**/
       /* Prompt to user enalbe/disable pushnotification */
      /* iOS 8 & 8< */
      if ([application
           respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
      {
            UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                            UIUserNotificationTypeBadge |
                                                            UIUserNotificationTypeSound);
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                     categories:nil];
            [application registerUserNotificationSettings:settings];
            [application registerForRemoteNotifications];
      }
      else
      {
            // iOS < 8 Notifications
            [application registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert |
              UIRemoteNotificationTypeSound)];
      }

          [self STORYBOARD_DIRECTION_Method]; /* direct the user based on login/guest user */
      return  [[FBSDKApplicationDelegate sharedInstance] application:application
                                       didFinishLaunchingWithOptions:launchOptions]; /* it always return true */
}


 /**__ Methods from didFinishLaunchingWithOptions __**/
-(void)NSUSER_Method
{
      [NSUSER setBool:FALSE forKey:@"pushnotification_enabled_in_device"]; /*  find the user enable/disable the pushnotification in device */
      [NSUSER setBool:TRUE forKey:@"splashscreen"]; 
      [NSUSER synchronize];
}

-(void)PARSE_Method :(NSDictionary *)launchOptions
{
      /** Change the parse application id and client id here **/
      [Parse setApplicationId:PARSE_APPLICATION_ID clientKey:PARSE_CLIENT_ID];
      [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
      // Set default ACLs
      PFACL *defaultACL = [PFACL ACL];
      [defaultACL setPublicReadAccess:YES]; /* The data is public which stored to the parse */
      [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}
-(void)COOKIES
{
      // Override point for customization after application launch.
      NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"SavedCookies"];
      if([cookiesdata length])
      {
            NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
            NSHTTPCookie *cookie;
            
            for (cookie in cookies)
            {
                  [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            }
      }
}

-(void)APPIRATER
{
      [Appirater setAppId:APPIRATER_ID]; /* Change the appiraterid in header.h */
      [Appirater setDaysUntilPrompt:0]; /* Daily Prompt if user click cancel */
      [Appirater setUsesUntilPrompt:3]; /* Show after 3rd time open the app */
      [Appirater setSignificantEventsUntilPrompt:-1];
      [Appirater setTimeBeforeReminding:2]; /* Remind it after 2 days when click remind later */
      [Appirater setDebug:NO]; /* if yes it show every time app opens */
      [Appirater appLaunched:YES];
}

-(void)STORYBOARD_DIRECTION_Method
{
      UIStoryboard *storyboard;
      
      if ([PFUser currentUser]) /* Authorised user direct to the RevolutionaryActsViewController Page */
      {
            [NSUSER setBool:TRUE forKey:@"showactoftheday"];
            [NSUSER synchronize];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                  storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            }
            else
            {
                  storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
            }
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"mainStoryboard"];
           [self.window makeKeyAndVisible];[[UIApplication sharedApplication] setStatusBarHidden:NO];
      }
      else /* UnAuthorised user direct to the LoginVC Page */
      {
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                  storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            }
            else
            {
                  storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
            }
            self.window.rootViewController = [storyboard instantiateInitialViewController];
            [self.window makeKeyAndVisible];[[UIApplication sharedApplication] setStatusBarHidden:NO];
      }
     

}


            /**__End of Methods from didFinishLaunchingWithOptions __**/



- (void)applicationWillResignActive:(UIApplication *)application
{
      NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
      NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
      [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"SavedCookies"];
      
      if (!curtain) {
            CGRect frame = self.viewController.view.frame;
            frame.size.height += 500; // uiwindow coordinates can be swapped from view coordinates.
            curtain = [[UIView alloc] initWithFrame:frame];
            curtain.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            curtain.backgroundColor = [UIColor colorWithRed:(0x6C / 255.0) green:(0xAC / 255.0) blue:(0xB9 / 255.0) alpha:1.0];
            [self.window addSubview:curtain];
      }
      curtain.hidden = NO;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{ /* This methods excute bcs user enable the pushnotification from the device settings */
      
      [NSUSER setBool:TRUE forKey:@"pushnotification_enabled_in_device"]; /* find the user enable/disable the pushnotification in device */
      
      if (![NSUSER boolForKey:@"alreadystored"]) /* It prevent every time call of parse installation (store device id). one time is enough */
      {
            [NSUSER setBool:TRUE forKey:@"alreadystored"];
            [NSUSER synchronize];
            if ([self check_network]) /*Check the Network connection is available or not */
            {
                  // Store the deviceToken in the current installation and save it to Parse.
                  PFInstallation *currentInstallation = [PFInstallation currentInstallation];/* This is the Class */
                  [currentInstallation setDeviceTokenFromData:deviceToken]; /*Store device token */
                   currentInstallation[@"pushnotification"]=@YES; /* Default set yes to pushnotification */
                  [currentInstallation saveInBackground]; /* run parse at background */
                  [NSUSER setBool:TRUE forKey:@"pushnotification"]; /*this nsuser used to set the switch in settings page */
            }
            else
            {
                  NSLog(@"The network connection not available");
            }
      }
      [NSUSER synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
      [PFPush handlePush:userInfo]; /* this get the user info and device info from info plist*/
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
      // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
       [FBSDKAppEvents activateApp]; /*This work during the time of facebook login */
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      curtain.hidden = YES;
      
      [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];/*this postnotification used for call the splashscree whenever the app coming to active (called from LoginVC and RevolutionaryActViewController)*/
      if ([self check_network]) /* check network Connection*/
      {
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            if (currentInstallation.badge != 0) /* Badge count */
            {
                  currentInstallation.badge = 0;
                  [currentInstallation saveEventually];
            }
      }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
      /*it return fb app if it is available otherwise it opens the safari browser */
      return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                            openURL:url
                                                  sourceApplication:sourceApplication
                                                         annotation:annotation
              ];
}


-(BOOL)check_network/* Check Network Connection */
{
      Reachability *reachability = [Reachability reachabilityForInternetConnection];
      NetworkStatus internetStatus = [reachability currentReachabilityStatus];
      if (internetStatus != NotReachable)
      {
            return YES;
      }
      return NO;
}


@end
