//
//  LaunchViewController.h
//  RevolutionaryActs
//
//  Created by Ira Mitchell on 8/25/11.
//  Copyright 2011 Drivetrain Agency LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RevolutionaryActsViewController;

@interface LaunchViewController : UIViewController <UIWebViewDelegate> {
  UIWebView *launchActWebView; 
  PopUpViewController *popUpViewController;
  RevolutionaryActsViewController *revolutionaryActsViewController;
  InternalBrowserController *internalBrowserController;
  BOOL needToShowRandomAct;
  BOOL needToShowRevDayAct;
  NSURL *buttonUrl;
      DTShareService *shareService;
}

- (IBAction)showRandomAct;
- (void)showRevDayAct;
- (IBAction)showExperienceLife;
- (IBAction)showRevolutionaryAct;
- (IBAction)closeView:(id)sender;

@property (nonatomic, retain) IBOutlet UIWebView *launchActWebView;
@property (nonatomic, retain) PopUpViewController *popUpViewController;
@property (nonatomic, retain) InternalBrowserController *internalBrowserController;
@property (nonatomic, retain) RevolutionaryActsViewController *revolutionaryActsViewController;
@property (nonatomic, assign) BOOL needToShowRandomAct;
@property (nonatomic, assign) BOOL needToShowRevDayAct;
@property (nonatomic, retain) NSURL *buttonUrl;


- (IBAction)share_action:(id)sender forEvent:(UIEvent *)event;
- (IBAction)settings_action:(id)sender;

@end

