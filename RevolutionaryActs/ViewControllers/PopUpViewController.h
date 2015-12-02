//
//  PopUpViewController.h
//  RevolutionaryActs
//
//  Created by Ira Mitchell on 8/19/11.
//  Copyright 2011 Drivetrain Agency LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RevolutionaryActsViewController;

@interface PopUpViewController : UIViewController <UIWebViewDelegate>
{
  UIWebView *webView;
  NSString *actNumber;
  InternalBrowserController *internalBrowserController;
  BOOL letWebviewHandleNextRequest;
  BOOL viewedNew;
  float heightAdjustment;
  NSURL *buttonUrl;
      DTShareService *shareService;
}

- (IBAction)closeView:(id)sender;
- (void)presentInternalBrowser: (NSURL*)urlPath;

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *actNumber;
@property (nonatomic, retain) InternalBrowserController *internalBrowserController;
@property (nonatomic, assign) RevolutionaryActsViewController *revolutionaryActsViewController;
@property (nonatomic, assign) BOOL viewedNew;
@property (nonatomic, assign) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) NSURL *buttonUrl;


- (IBAction)share_action:(id)sender forEvent:(UIEvent *)event;
- (IBAction)browse_action:(id)sender;
- (IBAction)surpriseme_action:(id)sender;
- (IBAction)settings_action:(id)sender;


@end
