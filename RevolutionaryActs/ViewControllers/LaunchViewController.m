//
//  LaunchViewController.m
//  RevolutionaryActs
//
//  Created by Ira Mitchell on 8/25/11.
//  Copyright 2011 Drivetrain Agency LLC. All rights reserved.
//

#import "LaunchViewController.h"

@implementation LaunchViewController

@synthesize launchActWebView, popUpViewController, internalBrowserController, revolutionaryActsViewController, needToShowRandomAct, needToShowRevDayAct, buttonUrl;


- (IBAction)closeView:(id)sender {
  //THIS GRANTS firstResponder STATUS to the revolutionaryActsViewController
//  [[self parentViewController] becomeFirstResponder];
  [self dismissViewControllerAnimated:YES completion:nil];
      [revolutionaryActsViewController browse];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  //NSLog(@"LaunchViewController didRotateFromInterfaceOrientation");
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    //for some reason the cornerRadius resets itself on orientation change
    self.view.layer.cornerRadius = 0;
  }
}

- (void) setBounds {
      /*
  //only done for iPad
  if ([self interfaceOrientation] == UIDeviceOrientationPortrait || [self interfaceOrientation] == UIDeviceOrientationPortraitUpsideDown) {
    //portrait
    self.view.superview.frame = CGRectMake(12, 230, 745, 560);  
  } else {
    //landscape
    self.view.superview.frame = CGRectMake(140, 100, 745, 560);  
  }
  self.view.layer.cornerRadius = 0;
       */
}

- (void)viewWillAppear:(BOOL)animated {
      [super viewWillAppear:YES];
  NSLog(@"LaunchViewController viewWillAppear");
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    // CALLS setBounds (which sets the frame size) after a 1/10th second delay
    //[self performSelector:@selector(setBounds) withObject:self afterDelay:0.01];
  }
  [[[launchActWebView subviews] lastObject] setScrollEnabled:NO];
}

- (void)displayRevActDay {
  //get the Random Day Value:
  // get the random act of the day using the following formula:
  // ((Epoch In Seconds  / (24*60*60)) % 101) + 1
  // use this to get epoch in seconds: (long)[[NSDate date] timeIntervalSince1970]];
  NSInteger num = (((long)[[NSDate date] timeIntervalSince1970] / (24*60*60)) % 101) + 1; //Generates Number from 1 to 101.
  NSString *dayAct = [NSString stringWithFormat:@"%li", (long)num];
  
  [launchActWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setDay(%@);", dayAct]]; 
}

- (void)viewDidLoad
{
  NSLog(@"LaunchViewController viewDidLoad");
  [super viewDidLoad];
      [NSUSER removeObjectForKey:@"showactoftheday"];
      [NSUSER synchronize];
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    [launchActWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"actoftheday" ofType:@"html"]]]];
  }else{ 
    [launchActWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"actoftheday-iphone" ofType:@"html"]]]];
  }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{
  NSLog(@"LaunchViewController shouldStartLoadWithRequest: %@", [request URL] );
  
  buttonUrl = [request URL];
  if ([[buttonUrl scheme] isEqualToString:@"revact"]) {
    [self showRevDayAct];
  } else if ([[buttonUrl scheme] isEqualToString:@"domloaded"]) {
    //this gets called due to <body onload="window.location='domloaded://loaded'"> when page is completely loaded
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){      
      if ([self interfaceOrientation] == UIDeviceOrientationPortrait || [self interfaceOrientation] == UIDeviceOrientationPortraitUpsideDown) {
        //portrait
        [revolutionaryActsViewController updateWebView:@"p"];  
      }
      else {
        //landscape
        [revolutionaryActsViewController updateWebView:@"l"];  
      }
    }
    [self displayRevActDay];
  }
  
  // Let system handle navigation.
  if(navigationType == UIWebViewNavigationTypeLinkClicked && (![[buttonUrl scheme] isEqualToString:@"revact"])) {
    if([[UIApplication sharedApplication] canOpenURL:buttonUrl]) {
      [self performSegueWithIdentifier:@"InternalBrowserSegue" sender:nil];
    } else {
      UIAlertView *alertView = [[UIAlertView alloc]
                                 initWithTitle:@"Link error."
                                 message:@"Cannot navigate to that link."
                                 delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
      [alertView show];
    }
    return NO;
  }
  return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
   NSLog(@"LaunchViewController didFailLoadWithError withError: %@", error );
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
  NSLog(@"LaunchViewController webViewDidFinishLoad");
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

- (void)viewDidDisappear:(BOOL)animated{
      [super viewDidDisappear:YES];
  //THIS GRANTS firstResponder STATUS to the revolutionaryActsViewController  
  if(needToShowRandomAct) {
    //[self performSelector:@selector(pressSurpriseMeButton) withObject:self.parentViewController afterDelay:0.001];
    [revolutionaryActsViewController RandomAct];
  }
  if(needToShowRevDayAct) {
    //[self performSelector:@selector(pressSurpriseMeButton) withObject:self.parentViewController afterDelay:0.001];
    [revolutionaryActsViewController showRandomDayAct];
  }
}

- (void)viewDidUnload
{
  NSLog(@"LaunchViewController viewDidUnload");

  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (IBAction)showRandomAct {
  NSLog(@"LaunchViewController showRandomAct");
  //NEED TO CALL THIS METHOD FROM THE RevolutionaryActsViewController AFTER closing the LaunchView.
  [self dismissViewControllerAnimated:YES completion:nil];
      //[revolutionaryActsViewController RandomAct];
  //set the needToShowRandomAct
  //[(RevolutionaryActsViewController*)self.parentViewController setNeedToShowRandomAct:YES];
  needToShowRandomAct = YES;
}

- (void)showRevDayAct {
  NSLog(@"LaunchViewController showRandomAct");
  //NEED TO CALL THIS METHOD FROM THE RevolutionaryActsViewController AFTER closing the LaunchView.  
  [self dismissViewControllerAnimated:YES completion:nil];
  
  // display the correct item in the webView.
  
  // make sure to link the Act of the Day properly using *dayAct.
  // call 
  
  //set the needToShowRandomAct
  //[(RevolutionaryActsViewController*)self.parentViewController setNeedToShowRandomAct:YES];
  needToShowRevDayAct = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    // Return YES for supported orientations
    return YES;
  }else{ 
    // Return YES for supported orientations
  return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
  }
}

- (IBAction)showExperienceLife {
  NSString *urlString = @"http://www.experiencelife.com";
  buttonUrl = [NSURL URLWithString:urlString];
    
  [self performSegueWithIdentifier:@"InternalBrowserSegue" sender:nil];
}

- (IBAction)showRevolutionaryAct {
  NSString *urlString = @"http://revolutionaryact.com";
  buttonUrl = [NSURL URLWithString:urlString];
    
  [self performSegueWithIdentifier:@"InternalBrowserSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"InternalBrowserSegue"]) {
    internalBrowserController = segue.destinationViewController;
    internalBrowserController.urlPath = buttonUrl;
  }
}

- (IBAction)share_action:(id)sender forEvent:(UIEvent *)event
{
      [self sharing:0];
      
}

- (IBAction)settings_action:(id)sender {
}
@end
