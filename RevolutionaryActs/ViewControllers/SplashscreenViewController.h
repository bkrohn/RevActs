//
//  SplashscreenViewController.h
//  RevolutionaryActs
//
//  Created by Dan Grigsby on 9/27/11.
//  Copyright 2011 Drivetrain Agency LLC. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SplashscreenViewController : UIViewController
{
  RevolutionaryActsViewController *revolutionaryActsViewController;
    //  LoginVC *loginvc;
  BOOL animationStarted;
  UIImageView *logoImageView;
  UIImageView *developedImageView;
  UIImageView *poweredImageView;
  UIImageView *libertyImageView;
  float heightAdjustment;
}

@property (nonatomic, retain) RevolutionaryActsViewController *revolutionaryActsViewController;
@property (nonatomic, retain) UIImageView *logoImageView;
@property (nonatomic, retain) UIImageView *developedImageView;
@property (nonatomic, retain) UIImageView *poweredImageView;
@property (nonatomic, retain) UIImageView *libertyImageView;
@property (strong, nonatomic) IBOutlet UIImageView *test1;

@end
