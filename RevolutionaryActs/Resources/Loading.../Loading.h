//
//  Loading.h
//  VMJ-STG
//
//  Created by Pasumai Solutions on 07/10/15.
//  Copyright © 2015 Michael Frederick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+animatedGIF.h"
@interface Loading : NSObject

@property (strong, nonatomic) UIView *LoadingView;
-(void)StartLoading :(UIView *)view;
-(void)StopLoading;
@end
