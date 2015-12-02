//
//  DTShareItem.h
//  ShareExample
//
//  Created by Pete Schwamb on 9/8/11.
//  Copyright 2011 Drivetrain Agency LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTShareItem : NSObject {
  NSString *link;
  NSString *body;
  NSString *subject;
}

- (id) initWithLink:(NSString *)newLink subject:(NSString*)newSubject andBody:(NSString*)newBody;

@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *subject;

@end
