//
//  DTShareItem.m
//  ShareExample
//
//  Created by Pete Schwamb on 9/8/11.
//  Copyright 2011 Drivetrain Agency LLC. All rights reserved.
//

#import "DTShareItem.h"

@implementation DTShareItem

@synthesize link, body, subject;

- (id) initWithLink:(NSString *)newLink subject:(NSString*)newSubject andBody:(NSString*)newBody {
  self = [super init];
  if (self != nil) {
    self.link = newLink;
    self.body = newBody;
    self.subject = newSubject;
  }
  return self;
}




@end