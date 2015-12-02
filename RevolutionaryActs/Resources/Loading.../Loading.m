//
//  Loading.m
//  VMJ-STG
//
//  Created by Pasumai Solutions on 07/10/15.
//  Copyright © 2015 Michael Frederick. All rights reserved.
//

#import "Loading.h"

@implementation Loading
UIView *vv;

-(void)StartLoading :(UIView *)view
{
      _LoadingView=[[UIView alloc] initWithFrame:CGRectMake((view.frame.size.width/2)-50, (view.frame.size.height/2)-50, 100, 100 )];
      _LoadingView.backgroundColor=[UIColor whiteColor];
      _LoadingView.layer.borderColor=[[UIColor grayColor] CGColor];
      _LoadingView.layer.borderWidth=0.0;
      _LoadingView.layer.cornerRadius=15;
      [view addSubview:_LoadingView];
      
      UIImageView *progress_imageview=[[UIImageView alloc] initWithFrame:CGRectMake((_LoadingView.frame.size.width/4), (_LoadingView.frame.size.height/4), 50, 50)];
      NSString *path=[[NSBundle mainBundle]pathForResource:@"hourglass" ofType:@"gif"];
      NSURL *url=[[NSURL alloc] initFileURLWithPath:path];
      progress_imageview.image= [UIImage animatedImageWithAnimatedGIFURL:url];
      [_LoadingView addSubview:progress_imageview];
      vv=_LoadingView;
      
}
-(void)StopLoading
{     [vv removeFromSuperview];
}
@end
