//
//  SplashscreenViewController.m
//  RevolutionaryActs
//
//  Created by Dan Grigsby on 9/27/11.
//  Copyright 2011 Drivetrain Agency LLC. All rights reserved.
//

#import "SplashscreenViewController.h"
@implementation SplashscreenViewController

@synthesize revolutionaryActsViewController, logoImageView, developedImageView, poweredImageView, libertyImageView;


- (void)viewDidLoad {
  NSLog(@"Splashscreen: viewDidLoad");
    
  [super viewDidLoad];
    heightAdjustment=0;
  if (IS_IPHONE_5)
  {
   // if (IS_HEIGHT_GTE_568) {
    //half of the 88
    heightAdjustment = 44;
  }
  
  self.view.backgroundColor = [UIColor colorWithRed:(0x6C / 255.0) green:(0xAC / 255.0) blue:(0xB9 / 255.0) alpha:1.0];
 [self performSelector:(@selector(dismiss)) withObject:nil afterDelay:4];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  animationStarted = YES;
  [self animate];
}

- (void)viewDidDisappear:(BOOL)animated
{
      [super viewDidDisappear:YES];
  NSLog(@"Splashscreen: ViewDidDisappear");
  //[self.revolutionaryActsViewController setFirstSplashAnimationView];
 // [self.revolutionaryActsViewController presentLaunchScreen];
}

- (void)dismiss
{
      [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)animate {
  NSLog(@"Splashscreen: animate");

  [self.logoImageView removeFromSuperview];
  [self.developedImageView removeFromSuperview];
  [self.poweredImageView removeFromSuperview];
  [self.libertyImageView removeFromSuperview];  
  
  CGRect developedEndFrame;
  CGRect logoEndFrame;
  CGRect poweredEndFrame;
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    UIImage *logoImage;
    UIImage *developedImage = [UIImage imageNamed:@"splashscreen_developed.png"];
    UIImage *poweredImage = [UIImage imageNamed:@"splashscreen_powered.png"];
    
    UIImage *libertyImage;
    
      logoImage = [UIImage imageNamed:@"splashscreen_logo_portrait.png"];
      libertyImage = [UIImage imageNamed:@"splashscreen_liberty_portrait.png"];
   
      
    self.logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    self.developedImageView = [[UIImageView alloc] initWithImage:developedImage];
    self.poweredImageView = [[UIImageView alloc] initWithImage:poweredImage];

  self.logoImageView.frame = CGRectMake(self.view.bounds.size.width , 0 - self.logoImageView.image.size.height, self.logoImageView.image.size.width, self.logoImageView.image.size.height);
    
        logoEndFrame = CGRectMake(((self.view.frame.size.width-self.logoImageView.image.size.width)/2)+30, 35, self.logoImageView.image.size.width, self.logoImageView.image.size.height);
   
    self.libertyImageView = [[UIImageView alloc] initWithImage:libertyImage];
    self.libertyImageView.frame = CGRectMake(self.view.frame.size.width-self.libertyImageView.image.size.width, self.view.frame.size.height-self.libertyImageView.image.size.height, self.libertyImageView.image.size.width, self.libertyImageView.image.size.height);
   
        self.poweredImageView.frame = CGRectMake( 0 - self.poweredImageView.image.size.width, self.view.bounds.size.height / 10, self.poweredImageView.image.size.width, self.poweredImageView.image.size.height);
        
        poweredEndFrame = CGRectMake( (self.view.bounds.size.width - self.poweredImageView.image.size.width) / 2, self.poweredImageView.frame.origin.y+100, self.poweredImageView.image.size.width, self.poweredImageView.image.size.height);
        
      self.developedImageView.frame = CGRectMake( (self.view.bounds.size.width - self.developedImageView.image.size.width) / 2, self.view.bounds.size.height-50, self.developedImageView.image.size.width, self.developedImageView.image.size.height);
      developedEndFrame = CGRectMake(self.developedImageView.frame.origin.x,  poweredEndFrame.origin.y+poweredEndFrame.size.height+100, self.developedImageView.image.size.width, self.developedImageView.image.size.height);
        
    
     }
      
      
      /** iPhone**/
  else {
    UIImage *logoImage = [UIImage imageNamed:@"banner.png"];
    UIImage *developedImage = [UIImage imageNamed:@"splashscreen_developed_iphone.png"];
    UIImage *poweredImage = [UIImage imageNamed:@"splashscreen_powered_iphone.png"];
    UIImage *libertyImage = [UIImage imageNamed:@"splashscreen_liberty_iphone.png"];
    
    self.logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    self.developedImageView = [[UIImageView alloc] initWithImage:developedImage];
    self.poweredImageView = [[UIImageView alloc] initWithImage:poweredImage];
    
    NSLog(@"view.bounds: %f|%f", self.view.bounds.size.height, self.view.bounds.size.width);
    NSLog(@"logo imageview frame width: %f", self.logoImageView.image.size.width);
    
    logoImageView.frame = CGRectMake(29 + heightAdjustment, -150, self.logoImageView.image.size.width, self.logoImageView.image.size.height);
        logoEndFrame =CGRectMake((self.view.frame.size.width-(self.logoImageView.image.size.width-150))/2, 29, self.logoImageView.image.size.width-150, 50);
    
    self.libertyImageView = [[UIImageView alloc] initWithImage:libertyImage];
    self.libertyImageView.frame = CGRectMake(self.view.frame.size.width-self.libertyImageView.image.size.width, self.view.frame.size.height-self.libertyImageView.image.size.height, self.libertyImageView.image.size.width, self.libertyImageView.image.size.height);
    
    self.developedImageView.frame = CGRectMake( 56.5 + 140 + heightAdjustment, 320 + 200, 107, 31);
    developedEndFrame = CGRectMake((self.view.frame.size.width-self.developedImageView.frame.size.width)/2, 250, self.developedImageView.image.size.width, self.developedImageView.image.size.height);
    
    self.poweredImageView.frame = CGRectMake( 0 - self.poweredImageView.image.size.width + (heightAdjustment * 2), 185, self.poweredImageView.image.size.width, self.poweredImageView.image.size.height);
    poweredEndFrame = CGRectMake((self.view.frame.size.width-self.poweredImageView.frame.size.width)/2, 150, self.poweredImageView.image.size.width, self.poweredImageView.image.size.height);
  }

  [self.view addSubview:self.libertyImageView];
  [self.view addSubview:self.logoImageView];
  [self.view addSubview:self.developedImageView];
  [self.view addSubview:self.poweredImageView];

      
  [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{    
        self.logoImageView.frame = logoEndFrame;
    self.developedImageView.frame = developedEndFrame;
    self.poweredImageView.frame = poweredEndFrame;
  } completion:^(BOOL finished) {
    NSLog(@"Animation finished");
  }];
  NSLog(@"Committed animation");        
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {  
  NSLog(@"Splashscreen: didRotateFromInterfaceOrientation");
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {  
    [self animate];
  } else {
    if (animationStarted == NO)
    [self animate];  
  } 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  NSLog(@"Splashscreen: shouldAutorotateToInterfaceOrientation");

  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    return (YES);
  else
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));    
}

@end
