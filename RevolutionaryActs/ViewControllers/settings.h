//
//  settings.h
//  RevolutionaryActs
//
//  Created by Pasumai Solutions on 26/10/15.
//  Copyright © 2015 Pasumai-Solutions Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface settings : UIViewController


/** Guest User **/
//@property (strong, nonatomic) IBOutlet UILabel *login_label;


/** Login User **/
@property (strong, nonatomic) IBOutlet UISwitch *newsletter_switch;
@property (strong, nonatomic) IBOutlet UISwitch *push_notification_switch;
@property (strong, nonatomic) IBOutlet UILabel *newsletter_label;
@property (strong, nonatomic) IBOutlet UILabel *push_notification_label;

- (IBAction)newsletter_switch_action:(id)sender;
- (IBAction)push_notification_switch_action:(id)sender;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logout_top_layout;


@property (strong, nonatomic) IBOutlet UIButton *logout_outlet;

- (IBAction)logout_action:(id)sender;

- (IBAction)exit_action:(id)sender;
@end
