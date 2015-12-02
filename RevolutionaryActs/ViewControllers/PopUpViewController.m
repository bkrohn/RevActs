//
//  PopUpViewController.m
//  RevolutionaryActs
//
//  Created by Ira Mitchell on 8/19/11.
//  Copyright 2011 Drivetrain Agency LLC. All rights reserved.
//

#import "PopUpViewController.h"
// need this for the square corners

@implementation PopUpViewController


@synthesize closeButton, webView, actNumber, internalBrowserController, revolutionaryActsViewController, viewedNew, buttonUrl;
NSURL *url;


- (IBAction)closeView:(id)sender
{
  //THIS GRANTS firstResponder STATUS to the revolutionaryActsViewController
//  [[self parentViewController] becomeFirstResponder];
  [self dismissViewControllerAnimated:YES completion:nil];
  
  if (viewedNew) {
    // ###########################################
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *updatedActsArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"array"]];
    
    NSString *actNum;
    
    for (int i = 0; i < [updatedActsArray count]; i++) {
      actNum = [updatedActsArray objectAtIndex:i];
      NSLog(@"actNumber|actNum: %@|%@", actNumber, actNum);
      if ([actNumber isEqualToString:actNum]) {
        [updatedActsArray removeObjectAtIndex:i];
//        [userDefaults setObject:@"new" forKey:@"act_state"];  
        
        [userDefaults setObject:updatedActsArray forKey:@"array"];
        [userDefaults synchronize];
        
        break;
      }
    }
    // ############################################
  }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  NSLog(@"PopUpViewController didRotateFromInterfaceOrientation");
  //for some reason the cornerRadius resets itself on orientation change
  self.view.layer.cornerRadius = 0;
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    [revolutionaryActsViewController scrollToActNumber:actNumber];
  }

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  heightAdjustment = 0;
  if (IS_IPHONE_5) {
  //  if (IS_HEIGHT_GTE_568) {
    //half of the 88
    heightAdjustment = 44;
  }
  
  letWebviewHandleNextRequest = YES;
  [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:actNumber ofType:@"html"]]]];    
  //set border radius on initial load
  self.view.layer.cornerRadius = 0;;
  
  // Create colored border using CALayer property
  [[webView layer] setBorderColor:
  [[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor]];
  [[webView layer] setBorderWidth:2.75];
  
  //set viewedNew boolean
  viewedNew = NO;
  

  if (IS_IPHONE_5) {
//  if(IS_HEIGHT_GTE_568) {
    CGRect frame = [closeButton frame];
    frame.origin.x += heightAdjustment * 2;  // change the location
    [closeButton setFrame:frame];
    
    frame = [webView frame];
    frame.size.width += heightAdjustment * 2;
    [webView setFrame:frame];
  }
}

- (void) setBounds
{
  if ([self interfaceOrientation] == UIDeviceOrientationPortrait || [self interfaceOrientation] == UIDeviceOrientationPortraitUpsideDown) {
    //portrait
    self.view.superview.frame = CGRectMake(12, 185, 745, 650);  
    //self.view.superview.center = self.view.center; 
  } else {
    //landscape
    self.view.superview.frame = CGRectMake(140, 55, 745, 650);  
    //self.view.superview.center = self.view.center; 
  }
  self.view.layer.cornerRadius = 0;
}

- (void)viewWillAppear:(BOOL)animated {
      [super viewWillAppear:YES];
  NSLog(@"PopUpViewController viewWillAppear");
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    // CALLS setBounds (which sets the frame size) after a 1/10th second delay
    //[self performSelector:@selector(setBounds) withObject:self afterDelay:0.01];
  }
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *updatedActsArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"array"]];
  
  NSString *actNum;
  
  for (int i = 0; i < [updatedActsArray count]; i++) {
    actNum = [updatedActsArray objectAtIndex:i];
    NSLog(@"actNumber|actNum: %@|%@", actNumber, actNum);
    if ([actNumber isEqualToString:actNum]) {
      [self.webView stringByEvaluatingJavaScriptFromString:@"showNews()"];
      
      // clear act_state
//      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"act_state"];
    } else {
      //HIDE ALL OF THE New! BY DEFAULT;
      //  [self.webView stringByEvaluatingJavaScriptFromString:@"$(\".new\").addClass(\"hide\");"];
      [self.webView stringByEvaluatingJavaScriptFromString:@"hideNews()"];
    }
  }
}

- (BOOL)webView:(UIWebView *) webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{
  NSLog(@"POPUP request = %@", request);
  
  NSLog(@"ContentViewController shouldStartLoadWithRequest: %@", [request URL] );
  url = [request URL];
      NSLog(@"url=%@",url);
  if(letWebviewHandleNextRequest) {
    letWebviewHandleNextRequest = NO;
    return YES;
  }
  
  // Let system handle navigation.
  if(navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeOther) {
    if ([[url scheme] isEqualToString:@"revact"]) {
      [revolutionaryActsViewController presentPopUp:[url host]];
    } else if ([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"]) {
      // TODO:
      // hide the [new] if it exists for this item.
      NSString *urlString = [url absoluteString];
      NSString *jsString = [NSString stringWithFormat:@"$('a[href*=\"%@\"]').find('.new').removeClass('show').addClass('hide');", urlString];
      NSLog(@"jsstring: %@", jsString);
      [self.webView stringByEvaluatingJavaScriptFromString:jsString]; 
      // this version hides all of the class=new elements... not what I want.
//    [self.webView stringByEvaluatingJavaScriptFromString:@"$('.new').addClass('clear');"];
      
      // set viewedNew boolean to true
      viewedNew = YES;
      
      //close the PopUpViewController
      //[revolutionaryActsViewController presentInternalBrowser:[request URL]];
      [self presentInternalBrowser:[request URL]];
    }    
    return NO;
  }
  return YES;
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

- (void)viewDidDisappear:(BOOL)animated
{
  if (viewedNew)
    [revolutionaryActsViewController updateActUpdated:actNumber];
  [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  NSLog(@"PopUpViewController shouldAutorotateToInterfaceOrientation");

  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    // Return YES for supported orientations
    return YES;
  }else{ 
    // Return YES for supported orientations
  return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"InternalBrowserSegue"])
    {
        internalBrowserController = segue.destinationViewController;
        internalBrowserController.urlPath = buttonUrl;;
    }
}

- (void)presentInternalBrowser: (NSURL*) urlPath
{
      if (![self check_network])
      {
            TOAST_FOR_INTERNET_CONNECTION;
      }
      else
      {
            internalBrowserController = [[InternalBrowserController alloc] init];
            self.buttonUrl = urlPath;
            [self performSegueWithIdentifier:@"InternalBrowserSegue" sender:nil];
      }
}

- (IBAction)share_action:(id)sender forEvent:(UIEvent *)event
{
      NSLog(@"%i",[actNumber intValue]);
      [self sharing:[actNumber intValue]];
}

- (IBAction)browse_action:(id)sender
{
      [self dismissViewControllerAnimated:TRUE completion:nil];
      [revolutionaryActsViewController browse];
}

- (IBAction)surpriseme_action:(id)sender
{
      [self dismissViewControllerAnimated:TRUE completion:nil];
      [revolutionaryActsViewController RandomAct];
}

- (IBAction)settings_action:(id)sender
{
}
@end
