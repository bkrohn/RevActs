//
// InternalBrowserController.m
// RevolutionaryActs
//
// Created by Ira Mitchell on 8/22/11.
// Copyright 2011 Drivetrain Agency LLC. All rights reserved.
//

#import "InternalBrowserController.h"

@implementation InternalBrowserController

@synthesize fullWebView, urlPath, fullUrl, shareToolbarButton, browserToolbarButton, closeToolbarButton, toolbarTitle; //, popUpViewController;


- (void)closeButtonTapped {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserButtonTapped {
    [self sendToSafari];
}

- (void)sendToSafari {
  [[UIApplication sharedApplication] openURL:urlPath];
}

- (BOOL)webView:(UIWebView *)fullWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  NSLog(@"InternalBrowserController shouldStartLoadWithRequest");
  NSLog(@"InternalBrowserController Request = %@", request);
  
  // Let system handle navigation.
  if(navigationType == UIWebViewNavigationTypeLinkClicked) {
    NSLog(@"ContentViewController shouldStartLoadWithRequest: %@", [request URL] );
  }
  return YES;
}

- (void)webView:(UIWebView *)fullWebView didFailLoadWithError:(NSError *)error
{
  if ([error code] != -999) {
    NSLog(@"didFailLoadWithError: %@", [error description]);
    [[[UIAlertView alloc] initWithTitle:nil message: [NSString stringWithFormat:@"An Internet connectivity error has prevented\n 101 Revolutionary Acts from continuing:\n%@", [[error localizedDescription] capitalizedString]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      // Custom initialization
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlPath];
  [fullWebView loadRequest:requestObj];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  // Grab the page title from the HTML page
  NSString* htmlPageTitle = [fullWebView stringByEvaluatingJavaScriptFromString: @"document.title"];
  [toolbarTitle setText:htmlPageTitle];
}


- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return YES;
}

- (IBAction)kjjhfg:(UIButton *)sender {
}

- (void)shareButtonTapped:(id)sender event:(UIEvent *)event {
      if (![self check_network])
      {
            TOAST_FOR_INTERNET_CONNECTION;
      }
      else
      {
  if (shareService == nil) {
    shareService = [[DTShareService alloc] init];
  }
    //shareService = [[DTShareService alloc] initWithController:self];
  }
  
  NSString *currentURL = fullWebView.request.URL.absoluteString;
  NSString *htmlPageTitle = [fullWebView stringByEvaluatingJavaScriptFromString: @"document.title"];
  if (currentURL.length == 0) {
    currentURL = @"http://experiencelife.com"; // If they share before the webview is ready
    htmlPageTitle = @"Experience Life";
  } 

  DTShareItem *item = [[DTShareItem alloc] initWithLink:currentURL subject:htmlPageTitle andBody:@"Shared via “101 Ways” mobile app by Experience Life & RevolutionaryAct.com"];
  
  UIActionSheet *sheet = [shareService share:item forController:self];
  UIView *view = [[event.allTouches anyObject] view];
  [sheet showFromRect:view.frame inView:self.view animated:YES];
}



@end