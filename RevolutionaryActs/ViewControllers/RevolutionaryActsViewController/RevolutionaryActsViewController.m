//
//  RevolutionaryActsViewController.m
//  RevolutionaryActs
//
//  Created by Ira Mitchell on 8/17/11.
//  Copyright 2011 Drivetrain Agency LLC. All rights reserved.
//

#import "RevolutionaryActsViewController.h"

//#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.width - ( double )568 ) < DBL_EPSILON )
#define IS_OS_6_OR_EARLIER    ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)

@implementation RevolutionaryActsViewController

@synthesize scrollView, popUpViewController, internalBrowserController, launchViewController, banner, surpriseMe, poweredBy, andImage, experienceLife, revolutionaryAct, buttonUrl, selectedAct, webView, userDefaults;

@synthesize window = _window;
@synthesize viewController = _viewController;

NSMutableArray *updatedActsArray;
CGColorRef outerColor, innerColor;


- (void)viewDidAppear:(BOOL)animated
{
      [super viewDidAppear:animated];
      [self becomeFirstResponder];
      NSLog(@"%@",_login_segue);
      if ([NSUSER boolForKey:@"showactoftheday"])
      {
            _login_segue=nil;
            [self performSelector:@selector(presentLaunchScreen) withObject:nil afterDelay:4];
      }
      else if (_login_segue)
      {
            _login_segue=nil;
            [self presentLaunchScreen];
      }
}

- (void)viewWillAppear:(BOOL)animated {
      [super viewWillAppear:YES];
      if (!maskLayer)
      {
            maskLayer = [CAGradientLayer layer];
            outerColor = [UIColor colorWithWhite:0.0 alpha:0.0].CGColor;
            innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
            maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor,
                                (__bridge id)innerColor, (__bridge id)innerColor, (__bridge id)outerColor, nil];
            maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                                   [NSNumber numberWithFloat:0.2],
                                   [NSNumber numberWithFloat:0.8],
                                   [NSNumber numberWithFloat:1.0], nil];
            maskLayer.bounds = CGRectMake(_ActTableView.frame.origin.x, _ActTableView.frame.origin.y,
                                          _ActTableView.frame.size.width,
                                          _ActTableView.frame.size.height);
            maskLayer.anchorPoint = CGPointZero;
            //[self gradientView:0];
            _ActTableView.layer.mask = maskLayer;
      }
      
      
}

-(void)gradientView :(int)call
{
      outerColor = [UIColor colorWithWhite:0.0 alpha:0.0].CGColor;
      innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
      //full Gradient
      if (call == 0)
      {
            maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor,
                                (__bridge id)innerColor, (__bridge id)innerColor, (__bridge id)outerColor, nil];
      }
      //Bottom gradient
      else if(call == 1)
      {
            maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)innerColor,
                                (__bridge id)innerColor, (__bridge id)innerColor, (__bridge id)outerColor, nil];
      }
      //Top Gradient
      else
      {
            maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor,
                                (__bridge id)innerColor, (__bridge id)innerColor, (__bridge id)innerColor, nil];
      }
      maskLayer.bounds = CGRectMake(_ActTableView.frame.origin.x, _ActTableView.frame.origin.y,
                                    _ActTableView.frame.size.width,
                                    _ActTableView.frame.size.height);
      _ActTableView.layer.mask = maskLayer;
}

- (void)didReceiveMemoryWarning
{
      // Releases the view if it doesn't have a superview.
      [super didReceiveMemoryWarning];
      // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
      [self toast_from_loginpage:_login_segue];
      UPDATE_SETTINGS;
      CHECK_USER_DISABLE_PUSHNOTIFICATION_ON_DEVICE;
      //  _ActTableView.alpha=2.0;
      updatedActsArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"array"]];
      NSLog(@"RevolutionaryActsController viewDidLoad");
      [super viewDidLoad];
      
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSplashScreen) name:@"appDidBecomeActive" object:nil];
      
      heightAdjustment = 0;
      if (IS_IPHONE_5) {
            //if (IS_HEIGHT_GTE_568) {
            //half of the 88
            heightAdjustment = 44;
      }
      
      NSString *version = [[NSUserDefaults standardUserDefaults] stringForKey:@"version"];
      NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
      
      NSLog(@"version %@ | currentVersion %@", version, currentVersion);
      
      if (![version isEqualToString:currentVersion]) {
            
            NSMutableArray *initialUpdatedActsArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"24",@"26",@"28",@"31",@"33",@"54",@"55",@"56",@"57",@"60",@"61",@"62",@"63",@"67",@"68",@"70",@"73",@"77",@"87",@"89",@"95",@"96",nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:initialUpdatedActsArray forKey:@"array"];
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"version"];
            [[NSUserDefaults standardUserDefaults] synchronize];
      }
      
      
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            if (webView == nil) {
                  webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
                  webView.delegate = self;
                  
                  NSLog(@"Created webView for RevolutionaryActsController");
                  
                  [scrollView addSubview:webView];
                  
                  for (id subview in webView.subviews) {
                        if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
                              ((UIScrollView *)subview).bounces = NO;
                        }
                  }
                  
                  [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"acts" ofType:@"html"]]]];
            }
            
      }
}

- (void)viewDidUnload
{
      [super viewDidUnload];
}
- (void)scrollToActNumber:(NSString*)actNumber
{
      
}
- (void)updateActUpdated:(NSString*)actNumber
{
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            NSLog(@"RevolutionaryActsViewController updateActUpdated: %@", actNumber);
            NSString *javascriptString = [NSString stringWithFormat:@"clearUpdatedBanner('%@')", actNumber];
            [webView stringByEvaluatingJavaScriptFromString:javascriptString];
      }
      
      // ###########################################
      userDefaults = [NSUserDefaults standardUserDefaults];
      
}

- (void)updateWebView:(NSString*)orientation {
      NSLog(@"RevolutionaryActsViewController updateWebView");
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            int pageNumber;
            int offsetX;
            if([orientation isEqualToString:@"p"]) {
                  pageNumber = (int)(scrollView.contentOffset.x / 714);
                  NSLog(@"PAGE: %i | %@", pageNumber, orientation);
                  scrollView.contentSize = CGSizeMake(6426, 731); //714w * 9screens = 6426 - 714 = 5712 (last page offset)
                  self.scrollViewHeightConstraint.constant = 731;
                  webView.frame = CGRectMake(0, 0, 6426, 731);
                  [webView stringByEvaluatingJavaScriptFromString:@"toggleOrientation('p');"];
                  
                  if (IS_OS_6_OR_EARLIER) {
                        self.bannerTopVerticalSpaceConstraint.constant = 35;
                  } else {
                        self.bannerTopVerticalSpaceConstraint.constant = 9;
                  }
                  self.bannerBottomVerticalSpaceConstraint.constant = 44;
                  self.bottomButtonsVerticalSpaceConstraint.constant = 44;
                  
                  //This is the scroll to page code
                  pageNumber = (scrollView.contentOffset.x / 714);
                  offsetX = 714 * pageNumber;
                  [scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
            }
            
            
            
            else {
                  pageNumber = (int)((scrollView.contentOffset.x / 968) + 1);
                  NSLog(@"PAGE: %i | %@", pageNumber, orientation);
                  scrollView.contentSize = CGSizeMake(588, 7744); //968w * 8screens = 7744 - 968 = 6776 (last page offset)
                  self.scrollViewHeightConstraint.constant = 7744;
                  webView.frame = CGRectMake(0, 0, 588, 7744);
                  [webView stringByEvaluatingJavaScriptFromString:@"toggleOrientation('l');"];
                  
                  self.bannerBottomVerticalSpaceConstraint.constant = 10;
                  if (IS_OS_6_OR_EARLIER) {
                        self.bannerTopVerticalSpaceConstraint.constant = 10;
                        self.bottomButtonsVerticalSpaceConstraint.constant = 25;
                  } else {
                        self.bannerTopVerticalSpaceConstraint.constant = 5;
                        self.bottomButtonsVerticalSpaceConstraint.constant = 15;
                  }
                  
                  //This is the scroll to page code
                  //Keeps the
                  if(scrollView.contentOffset.x == 0)
                  {
                        pageNumber = (scrollView.contentOffset.x / 968);
                  }
                  else
                  {
                        pageNumber = ((scrollView.contentOffset.x / 968) + 1);
                        if(firstSplashAnimationView || pageNumber == 8) {
                              pageNumber = pageNumber - 1;
                              firstSplashAnimationView = NO;
                        }
                  }
                  
                  offsetX = 968 * pageNumber;
                  [scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
            }
      }
}

- (void)setFirstSplashAnimationView
{
      firstSplashAnimationView = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
      NSLog(@"RevolutionaryActsViewController shouldAutorotateToInterfaceOrientation");
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            // Return YES for supported orientations
            return YES;
      }else{
            // Return YES for supported orientations
            return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
      }
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
      NSLog(@"RevolutionaryActsController willRotateToInterfaceOrientation");
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            if (orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown) {
                  // do something here for these orientations, assume Portrait?
            } else {
                  if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
                        //portrait
                        [self updateWebView:@"p"];
                  }
                  else {
                        //landscape
                        [self updateWebView:@"l"];
                  }
            }
      }
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            NSSet *set = [event touchesForView:self.scrollView];
            
            NSEnumerator *enumerator = [set objectEnumerator];
            UITouch *touch;
            
            while ((touch = (UITouch *)[enumerator nextObject])) {
                  CGPoint location = [touch locationInView:self.scrollView];
                  [self presentPopUp:[NSString stringWithFormat:@"%i", (int)(location.y / 140) + 1]];
            }
      }
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
      // #########################################
      
      NSMutableArray *updatedActsArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"array"]];
      NSString *joinedString = [updatedActsArray componentsJoinedByString:@","];
      
      NSLog(@"RevolutionaryActsViewController updateActUpdated: %@", joinedString);
      
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            NSString *javascriptString = [NSString stringWithFormat:@"setUpdated('%@')", joinedString];
            [self.webView stringByEvaluatingJavaScriptFromString:javascriptString];
      }
      // ###########################################
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
      NSLog(@"RevolutionaryActsController didFailLoadWithError: %@", error);
}

- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
      NSLog(@"RevolutionaryActsController shouldStartLoadWithRequest");
      
      NSURL *url = [request URL];
      if ([[url scheme] isEqualToString:@"revact"]) {
            //set actNumber to the value for [request URL];
            [self presentPopUp:[url host]];
      } else if ([[url scheme] isEqualToString:@"http"]) {
            //[self presentPopUp:[url host]];
            [self presentInternalBrowser:url];
      } else if ([[url scheme] isEqualToString:@"domloaded"]) {
            //this gets called due to <body onload="window.location='domloaded://loaded'"> when page is completely loaded
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                  if ([self interfaceOrientation] == UIDeviceOrientationPortrait || [self interfaceOrientation] == UIDeviceOrientationPortraitUpsideDown) {
                        //portrait
                        [self updateWebView:@"p"];
                  }
                  else {
                        //landscape
                        [self updateWebView:@"l"];
                  }
            }
      }
      
      // Let system handle navigation.
      if(navigationType == UIWebViewNavigationTypeLinkClicked && (![[url scheme] isEqualToString:@"revact"])) {
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                  [self presentInternalBrowser:url];
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


- (void)presentPopUp: (NSString*) actNum
{
      NSLog(@"RevolutionaryActsController presentPopUp");
      [self resignFirstResponder];
      
      self.selectedAct = actNum;
      NSLog(@"selectedAct: %@", actNum);
      
      [self performSegueWithIdentifier:@"PopUpScreenSegue" sender:nil];
}

- (void)presentInternalBrowser: (NSURL*) urlPath {
      NSLog(@"RevolutionaryActsViewController presentInternalBrowser");
      
      [self performSegueWithIdentifier:@"InternalBrowserSegue" sender:nil];
}

- (void)presentSplashScreen
{
      
      SplashscreenViewController *splashscreenViewController = [[SplashscreenViewController alloc] init];
      splashscreenViewController.revolutionaryActsViewController = self;
      [self presentViewController:splashscreenViewController animated:NO completion:nil];
      
}

- (void)presentLaunchScreen
{
      NSLog(@"RevolutionaryActsViewController presentLaunchScreen");
      [self performSegueWithIdentifier:@"LaunchScreenSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
      UIViewController *floatingIPadViewController = [[UIViewController alloc] init];
      
      if ([segue.identifier isEqualToString:@"PopUpScreenSegue"]) {
            popUpViewController = [[PopUpViewController alloc] init];
            popUpViewController = segue.destinationViewController;
            popUpViewController.revolutionaryActsViewController = self;
            popUpViewController.actNumber = selectedAct;
            floatingIPadViewController = popUpViewController;
      } else if ([segue.identifier isEqualToString:@"LaunchScreenSegue"]) {
            launchViewController = [[LaunchViewController alloc] init];
            launchViewController = segue.destinationViewController;
            launchViewController.revolutionaryActsViewController = self;
            [self resignFirstResponder];
            floatingIPadViewController = launchViewController;
      } else if ([segue.identifier isEqualToString:@"InternalBrowserSegue"]) {
            internalBrowserController = [[InternalBrowserController alloc] init];
            internalBrowserController = segue.destinationViewController;
            internalBrowserController.urlPath = buttonUrl;;
      }
      
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            if ([self interfaceOrientation] == UIDeviceOrientationPortrait || [self interfaceOrientation] == UIDeviceOrientationPortraitUpsideDown) {
                  //portrait
                  floatingIPadViewController.view.superview.frame = CGRectMake(12, 230, 745, 560);
            } else {
                  //landscape
                  floatingIPadViewController.view.superview.frame = CGRectMake(140, 100, 745, 560);
            }
      }
}

- (IBAction)pressRevActsButton {
      NSLog(@"RevolutionaryActsViewController pressRevActsButton");
      
      NSString *cUrl = @"http://revolutionaryact.com/";
      buttonUrl = [NSURL URLWithString:cUrl];
      
      [self performSegueWithIdentifier:@"InternalBrowserSegue" sender:nil];
}

- (IBAction)pressExpLifeButton {
      
      NSString *bUrl = @"http://experiencelife.com/";
      buttonUrl = [NSURL URLWithString:bUrl];
      
      [self performSegueWithIdentifier:@"InternalBrowserSegue" sender:nil];
}

- (void)showRandomDayAct
{
      NSLog(@"RevolutionaryActsViewController showRandomDayAct");
      //resignFirstResponder to prevent shake while act is appearing
      [self resignFirstResponder];
      
      // get the random act of the day using the following formula:
      // ((Epoch In Seconds  / (24*60*60)) % 101) + 1
      // use this to get epoch in seconds: (long)[[NSDate date] timeIntervalSince1970]];
      NSInteger num = (((long)[[NSDate date] timeIntervalSince1970] / (24*60*60)) % 101) + 1; //Generates Number from 1 to 101.
      self.selectedAct = [NSString stringWithFormat:@"%li", (long)num];
      
      [_ActTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:num] atScrollPosition:UITableViewScrollPositionTop animated:YES];
      CGPoint point = _ActTableView.contentOffset;
      point .y -= _ActTableView.rowHeight;
      _ActTableView.contentOffset = point;
      
      // run the scrollView and then wait a second to show popUp.
      [self performSelector:@selector(presentPopUp:) withObject:self.selectedAct afterDelay:0.5];
}

- (IBAction)showLaunchScreen
{
      [self presentLaunchScreen];
}




- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
      NSLog(@"RevolutionaryActsController motionEnded");
      
      if (motion == UIEventSubtypeMotionShake)
      {
            NSLog(@"Was shaken");
            [self RandomAct];
      }
}

// this needs to be true for shake
- (BOOL)canBecomeFirstResponder {
      NSLog(@"RevolutionaryActsController canBecomeFirstResponder");
      return YES;
}






/** New Approach through UITableView **/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
      return 101;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
      {
            return 300;
      }
      else
            return 150;
      
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
      return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
      
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
      {
            cell.act_imageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%li_iphone@2x.png",indexPath.section+1]];
      }
      else
      {
            cell.act_imageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%li_portrait.png",indexPath.section+1]];
      }
      if ([self find_data_in_arr:updatedActsArray :[NSString stringWithFormat:@"%li",indexPath.section+1]])
      {
            cell.updated_imageview.hidden=NO;
      }
      else
      {
            cell.updated_imageview.hidden=YES;
      }
      
      
      
      
      return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      [self performSelector:@selector(presentPopUp:) withObject:[NSString stringWithFormat:@"%li",indexPath.section+1] afterDelay:0.5];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
      UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_ActTableView.frame.origin.x, 0, _ActTableView.frame.size.width, 5)];
      view.backgroundColor = [UIColor clearColor];
      return view;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
      [CATransaction begin];
      [CATransaction setDisableActions:YES];
      maskLayer.position = CGPointMake(0,scrollView_.contentOffset.y);
      NSLog(@"%f",scrollView_.contentOffset.y);
      
      /** Top hide**/
      if (scrollView_.contentOffset.y<100.0f)
      {
            [self gradientView:1];
      }
      /** Bottom hide **/
      else if((scrollView_.contentOffset.y>15200.0f && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) || (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && scrollView_.contentOffset.y>29700.0f))
      {
            [self gradientView:2];
      }
      else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && self.view.frame.size.height>700 && scrollView_.contentOffset.y>15000)
      {
            [self gradientView:2];
      }
      /** Full gradient **/
      else
      {
            [self gradientView:0];
      }
      [CATransaction commit];
}

-(BOOL)find_data_in_arr:(NSMutableArray *)arr :(NSString *)data
{
      NSInteger anIndex=[arr indexOfObject:data];
      if(NSNotFound == anIndex)
      {     return FALSE;           }
      else
      {     return TRUE;            }
}
- (IBAction)share_action:(id)sender forEvent:(UIEvent *)event
{
      [self sharing:0];
}

- (IBAction)browse_action:(id)sender
{
      [self browse];
}


- (IBAction)surpriseme_action:(id)sender
{
      [self RandomAct];
}

-(void)RandomAct
{
      [self resignFirstResponder];
      //generate a random number
      NSInteger number = (arc4random()%101)+1; //Generates Number from 1 to 101.
      self.selectedAct = [NSString stringWithFormat:@"%li", (long)number];
      if (number == 101)
      {
            number=100;
      }
      [_ActTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:number] atScrollPosition:UITableViewScrollPositionTop animated:YES];
      CGPoint point = _ActTableView.contentOffset;
      point .y -= _ActTableView.rowHeight;
      _ActTableView.contentOffset = point;
      
      // run the scrollView and then wait a second to show popUp.
      [self performSelector:@selector(presentPopUp:) withObject:self.selectedAct afterDelay:0.5];
}
-(void)browse
{
      [_ActTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
      CGPoint point = _ActTableView.contentOffset;
      point .y -= _ActTableView.rowHeight;
      _ActTableView.contentOffset = point;
      [self gradientView:1];
}
- (IBAction)settings_action:(id)sender
{
}
@end
