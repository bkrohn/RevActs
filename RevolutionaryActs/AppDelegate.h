//
//  AppDelegate.h
//  RevolutionaryActs
//
//  Created by Pasumai Solutions on 23/10/15.
//  Copyright © 2015 Pasumai-Solutions Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+RevolutionaryViewControllers.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
      UIView *curtain;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) RevolutionaryActsViewController *viewController;
@end

