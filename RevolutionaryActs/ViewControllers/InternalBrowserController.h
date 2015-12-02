//
// InternalBrowserController.h
// RevolutionaryActs
//
// Created by Ira Mitchell on 8/22/11.
// Copyright 2011 Drivetrain Agency LLC. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface InternalBrowserController : UIViewController <UIAlertViewDelegate, UIWebViewDelegate>{
  UIWebView *fullWebView;
  NSURL *urlPath;
  NSString *fullUrl;
  IBOutlet UILabel *toolbarTitle;
  IBOutlet UIButton *shareToolbarButton;
  IBOutlet UIButton *browserToolbarButton;
  IBOutlet UIButton *closeToolbarButton;
  DTShareService *shareService;
}

- (IBAction)shareButtonTapped:(id)sender event:(UIEvent *)event;
- (IBAction)browserButtonTapped;
- (IBAction)closeButtonTapped;
- (void) sendToSafari;

@property (nonatomic, retain) IBOutlet UIWebView *fullWebView;
@property (nonatomic, retain) NSURL *urlPath;
@property (nonatomic, retain) NSString *fullUrl;
@property (nonatomic, retain) IBOutlet UILabel *toolbarTitle;
@property (nonatomic, retain) IBOutlet UIButton *shareToolbarButton;
@property (nonatomic, retain) IBOutlet UIButton *browserToolbarButton;
@property (nonatomic, retain) IBOutlet UIButton *closeToolbarButton;

@end

