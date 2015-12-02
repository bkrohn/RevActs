//
//  RevolutionaryActsViewController.h
//  RevolutionaryActs
//
//  Created by Ira Mitchell on 8/17/11.
//  Copyright 2011 Drivetrain Agency LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActTableviewCell.h"
#import "PopUpViewController.h"
#import "LaunchViewController.h"
@interface RevolutionaryActsViewController : UIViewController <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
      UIScrollView *scrollView;
      UIWebView *webView;
      UIButton *banner;
      UIButton *surpriseMe;
      UIImageView *andImage;
      UIImageView *poweredBy;
      UIButton *revolutionaryAct;
      UIButton *experienceLife;
      PopUpViewController *popUpViewController;
      InternalBrowserController *internalBrowserController;
      LaunchViewController *launchViewController;
      NSURL *buttonUrl;
      UIWindow *window;
      UIViewController *viewController;
      NSString *selectedAct;
      BOOL firstSplashAnimationView;
      float heightAdjustment;
      ActTableviewCell *cell;
      CAGradientLayer *maskLayer;
      DTShareService *shareService;
      
}

- (void)updateWebView:(NSString*)orientation;
- (void)updateActUpdated:(NSString*)actNumber;
- (void)presentPopUp: (NSString*)actNumber;
- (void)presentInternalBrowser: (NSURL*)urlPath;
- (void)presentLaunchScreen;
- (void)showRandomDayAct;
- (IBAction)pressExpLifeButton;
- (IBAction)pressRevActsButton;
- (IBAction)showLaunchScreen;
- (void)presentSplashScreen;
- (void)scrollToActNumber:(NSString*)actNumber;
- (void)setFirstSplashAnimationView;
-(void)RandomAct;
-(void)browse;


@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) PopUpViewController *popUpViewController;
@property (nonatomic, retain) InternalBrowserController *internalBrowserController;
@property (nonatomic, retain) LaunchViewController *launchViewController;
@property (nonatomic, retain) IBOutlet UIButton *banner;
@property (nonatomic, retain) IBOutlet UIButton *surpriseMe;
@property (nonatomic, retain) IBOutlet UIImageView *andImage;
@property (nonatomic, retain) IBOutlet UIImageView *poweredBy;
@property (nonatomic, retain) IBOutlet UIButton *revolutionaryAct;
@property (nonatomic, retain) IBOutlet UIButton *experienceLife;
@property (nonatomic, retain) NSURL *buttonUrl;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, retain) NSString *selectedAct;
@property (nonatomic, retain) NSUserDefaults *userDefaults;
@property (strong, nonatomic) NSString *login_segue;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bannerTopVerticalSpaceConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bannerBottomVerticalSpaceConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonsVerticalSpaceConstraint;

@property (retain, nonatomic) IBOutlet UITableView *ActTableView;
@property (strong, nonatomic) IBOutlet UIView *shortcut_key_views;

- (IBAction)share_action:(id)sender forEvent:(UIEvent *)event;
- (IBAction)browse_action:(id)sender;
- (IBAction)surpriseme_action:(id)sender;
- (IBAction)settings_action:(id)sender;




@property (strong, nonatomic) IBOutlet UIButton *share_outlet;



@end

