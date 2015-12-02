//
//  UIViewController+RevolutionaryViewControllers.h
//  RevolutionaryActs
//
//  Created by Pasumai Solutions on 26/10/15.
//  Copyright © 2015 Pasumai-Solutions Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RevolutionaryViewControllers)


-(NSString *)remove_whitespace:(NSString *)string_data;
-(BOOL)check_mail :(NSString *)email;
-(BOOL)equal_password :(NSString *)password confirm_password:(NSString *)confirm_password;
-(void)update_settings :(NSString *)fromdata;
-(BOOL)check_network;
-(void)sharing: (int)share_data;
-(void)toast_from_loginpage :(NSString *)string;
-(void)save_user_for_pushnotification :(BOOL)value;
-(void)pushnotification_on_device;
@end
