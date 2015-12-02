//
//  DTShareService.h
//  ShareExample
//
//  Created by Pete Schwamb on 9/8/11.
//  Copyright 2011 Drivetrain Agency LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DTShareItem.h"

@interface DTShareService : NSObject <MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
  UIViewController *currentController;
  DTShareItem *currentShareItem;
}

- (UIActionSheet*) share:(DTShareItem*)item forController:(UIViewController*)controller;

@property (nonatomic, retain) DTShareItem *currentShareItem;
@property (nonatomic, retain) UIViewController *currentController;

@end

