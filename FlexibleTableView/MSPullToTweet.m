//
//  MSPullToTweet.m
//  Day Player v1.1 new design
//
//  Created by Lion User on 23/06/2013.
//  Copyright (c) 2013 com.molased. All rights reserved.
//

#import "MSPullToTweet.h"
#import <Social/Social.h>
#import "MBAlertView/MBAlertView.h"
#import "Flurry.h"

@implementation UIImage (UIImageColoring)
- (UIImage *)imageWithOverlayColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    if (UIGraphicsBeginImageContextWithOptions) {
        CGFloat imageScale = 1.0f;
        if ([self respondsToSelector:@selector(scale)])  // The scale property is new with iOS4.
            imageScale = self.scale;
        UIGraphicsBeginImageContextWithOptions(self.size, NO, imageScale);
    }
    else {
        UIGraphicsBeginImageContext(self.size);
    }
    
    [self drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
@implementation MSPullToTweet
{
    UIViewController *_viewController;
    UIView *_view;
    
    id<MSPullToTweetDelegate> _delegate;
    
    CGPoint _originalCenter;
    
    CGFloat _twitterViewHeight;
    CGFloat _twitterViewMargin;
    
    BOOL _exceedRequiredSizeToTweet;
}
@synthesize twitterImageView= _twitterImageView;

-(void)viewDidLayoutSubviews
{
    _twitterImageView.frame = CGRectMake(0, -_twitterViewHeight-_twitterViewMargin, _view.frame.size.width, _twitterViewHeight);
}
-(id)initWithViewController:(UIViewController *)viewController imageView:(UIImageView *)imageView delegate:(id<MSPullToTweetDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        _viewController = viewController;
        _view = viewController.view;
        _delegate = delegate;
        
        _twitterViewHeight = 100;
        _twitterViewMargin = 10;
        
        _twitterImageView = imageView;
        
        //_twitterImageView.contentMode = UIViewContentModeScaleAspectFit ;
        
        //_twitterImageView.frame = CGRectMake(0, -_twitterViewHeight-_twitterViewMargin, _view.frame.size.width, _twitterViewHeight);
        
        //[_twitterView addSubview:_twitterImageView];
        
        
        UIPanGestureRecognizer *panGestureForTwitter = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureForTwitterHandler:)];
        panGestureForTwitter.delegate = self;
        
        [_view addGestureRecognizer:panGestureForTwitter];
    }
    return self;
}

-(id)initWithViewController:(UIViewController *)viewController delegate:(id<MSPullToTweetDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        _viewController = viewController;
        _view = viewController.view;
     
        
        _delegate = delegate;
        
        _twitterViewHeight = 100;
        _twitterViewMargin = 10;
        
        _twitterImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"twitter icon"]  imageWithOverlayColor:[UIColor lightGrayColor]]];
        
        _twitterImageView.contentMode = UIViewContentModeScaleAspectFit ;
        
        _twitterImageView.frame = CGRectMake(0, -_twitterViewHeight-_twitterViewMargin, _view.frame.size.width, _twitterViewHeight);
        
        [_view addSubview:_twitterImageView];
        
        
        UIPanGestureRecognizer *panGestureForTwitter = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureForTwitterHandler:)];
        panGestureForTwitter.delegate = self;
        
        [_view addGestureRecognizer:panGestureForTwitter];
    }
    return self;
}


-(void)panGestureForTwitterHandler:(UIPanGestureRecognizer*)panGesture
{
    
    if(panGesture.state == UIGestureRecognizerStateBegan)
    {
        
        _originalCenter = _view.center;
        
        
    }else if(panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [panGesture translationInView:_view];
        
        CGFloat offsetInY = MIN(translation.y, 2*_twitterViewMargin+_twitterViewHeight);
        offsetInY = MAX(offsetInY, 0);
        _view.center = CGPointMake(_originalCenter.x , _originalCenter.y + offsetInY);
        
        _exceedRequiredSizeToTweet = translation.y > _twitterViewHeight+_twitterViewMargin;
        
        _twitterImageView.image = _exceedRequiredSizeToTweet ? [_twitterImageView.image imageWithOverlayColor:[UIColor cyanColor]] : [_twitterImageView.image imageWithOverlayColor:[UIColor colorWithWhite:.15 alpha:1]];
        
        
    }else if(panGesture.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:.5 animations:^{
            
            _view.center = _originalCenter;
            //_view.transform = CGAffineTransformIdentity;
            
        }completion:^(BOOL finished) {
            if(_exceedRequiredSizeToTweet)
            {
                [self tweetCurrentTask];
            }
        }];
    }
    
}


-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] )
    {
        CGPoint translationPoint =  [gestureRecognizer translationInView:_view];
        if(translationPoint.y > 0 && [_delegate shouldStartGesture:gestureRecognizer])
        {
            return YES;
        }
        
        
    }
    return NO;
}
- (void)tweetCurrentTask
{
    [Flurry logEvent:@"tweet current task"];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *socialComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter ];
        NSString *currentTaskName = [_delegate currentTaskName];
        if(!currentTaskName) currentTaskName = @"do nothing";
        
        [socialComposer setInitialText:[NSString stringWithFormat:@"#now %@ via @dayplayerapp",currentTaskName]];
        
        
        [_viewController presentViewController:socialComposer animated:YES completion:nil];
        
        
        
    }else
    {
        MBAlertView *alertView = [MBAlertView alertWithBody:@"you have to log in twitter from setting/twitter" cancelTitle:@"dismiss" cancelBlock:nil];
        [alertView setAlertViewSize];
        [alertView addToDisplayQueue];
        
    }
}
@end
