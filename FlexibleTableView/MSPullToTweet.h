//
//  MSPullToTweet.h
//  Day Player v1.1 new design
//
//  Created by Lion User on 23/06/2013.
//  Copyright (c) 2013 com.molased. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSPullToTweetDelegate <NSObject>


-(NSString *)currentTaskName;
-(BOOL)shouldStartGesture:(UIGestureRecognizer*)gestureRecognizer;
@end

@interface MSPullToTweet : NSObject <UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIImageView *twitterImageView;
-(id)initWithViewController:(UIViewController *)viewController delegate:(id<MSPullToTweetDelegate>)delegate;
-(id)initWithViewController:(UIViewController*)viewController imageView:(UIImageView*)imageView delegate:(id<MSPullToTweetDelegate>)delegate;

-(void)viewDidLayoutSubviews;
@end
