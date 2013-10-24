//
//  MSUtilitiesGesturesHandler.m
//  PinchToAddCell
//
//  Created by Lion User on 10/06/2013.
//  Copyright (c) 2013 com.molased. All rights reserved.
//

#import "MSUtilitiesGesturesHandler.h"

#import <QuartzCore/QuartzCore.h>

@implementation MSUtilitiesGesturesHandler
{
    UITableView *_tableView;
}

-(id)initWithTableView:(UITableView *)tableView delegate:(id<MSUtilitiesGestureHandlerProtocol>)delegate
{
    if(self= [super init])
    {
        _tableView = tableView;
        self.delegate = delegate;
        
        
        UITapGestureRecognizer *oneTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapGestureHandler:)];
        oneTapGesture.delegate = self;
        [_tableView addGestureRecognizer:oneTapGesture];
        
        UITapGestureRecognizer *twoTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoTapGestureHandler:)];
        twoTapGesture.numberOfTapsRequired = 2;
        twoTapGesture.delegate = self;
        //[_tableView addGestureRecognizer:twoTapGesture];
        
        UITapGestureRecognizer *twoTouchesGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoTouchesGestureHandler:)];
        twoTouchesGesture.numberOfTouchesRequired = 2;
        twoTouchesGesture.delegate = self;
        [_tableView addGestureRecognizer:twoTouchesGesture];
        
        
        //[oneTapGesture requireGestureRecognizerToFail:twoTapGesture];
        
        UITapGestureRecognizer *threeTouchesGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(threeTouchesGestureHandler:)];
        threeTouchesGesture.numberOfTouchesRequired = 3;
        threeTouchesGesture.delegate = self;
        [_tableView addGestureRecognizer:threeTouchesGesture];
    }
    return self;
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
        return [self.delegate shouldStartGesture:gestureRecognizer];
}
-(void)twoTapGestureHandler:(UITapGestureRecognizer*)oneTapGesture
{
    CGPoint gestureLocationInTable = [oneTapGesture locationInView:_tableView];
    NSIndexPath *indexPath =  [_tableView indexPathForRowAtPoint:gestureLocationInTable];
    [self.delegate playTaskAtIndexPath:indexPath];
    NSInteger numberOfRows = [self.delegate tableView:_tableView numberOfRowsInSection:0];
    
    
        [CATransaction begin];
        [CATransaction setAnimationDuration:5];
        [CATransaction setCompletionBlock:^{
            
            [self.delegate reloadData];
        }];
        
        NSIndexPath *fromIndexPath  = [self indexPathForRowAtIndex:0];
        NSIndexPath *toIndexPath  = [self indexPathForRowAtIndex:numberOfRows-1];
        for(int i = indexPath.row;i>0;i--)
        {
            
            
            
            [_tableView beginUpdates];
//            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:fromIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//            [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:toIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [_tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
            
            [_tableView scrollToRowAtIndexPath:[self indexPathForRowAtIndex:i] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            [self.delegate needsMoveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
            [_tableView endUpdates];
            
            
        }
        
        [CATransaction commit];
    [self.delegate playTaskAtIndexPath:fromIndexPath];
    
}

-(NSIndexPath*)indexPathForRowAtIndex:(NSInteger)index
{
    return [NSIndexPath indexPathForRow:index inSection:0];
}

-(void)oneTapGestureHandler:(UITapGestureRecognizer*)oneTapGesture
{
    CGPoint gestureLocationInTable = [oneTapGesture locationInView:_tableView];
    NSIndexPath *indexPath =  [_tableView indexPathForRowAtPoint:gestureLocationInTable];
    
    // here we should say show editdialog instead of direct edit declaration
//    CGFloat tableWidth = _tableView.frame.size.width;
//    if(gestureLocationInTable.x < tableWidth/4)
//    {
//        
//        [MBHUDView hudWithBody:@"-5" type:MBAlertViewHUDTypeDefault hidesAfter:.01 show:YES];
//        [self.delegate decreaseRemainingTimeForCellAtIndex:indexPath.row];
//    }else if(gestureLocationInTable.x > 3*tableWidth/4)
//    {
//        [MBHUDView hudWithBody:@"+5" type:MBAlertViewHUDTypeDefault hidesAfter:.01 show:YES];
//        [self.delegate increaseRemainingTimeForCellAtIndex:indexPath.row];
//    }else
    {
        [self.delegate showInsertionDialogAtIndex:indexPath.row withFrame:_tableView.frame isEdit:YES];
    }

    
}
-(void)twoTouchesGestureHandler:(UITapGestureRecognizer*)oneTapGesture
{
    CGPoint gestureLocationInTable = [oneTapGesture locationInView:_tableView];
    NSIndexPath *indexPath =  [_tableView indexPathForRowAtPoint:gestureLocationInTable];
    [self.delegate setTaskAsLastToPlayAtIndexPath:indexPath];
    [self.delegate reloadData];
}
-(void)threeTouchesGestureHandler:(UITapGestureRecognizer*)threeTouchesGesture
{
    CGPoint gestureLocationInTable = [threeTouchesGesture locationInView:_tableView];
    NSIndexPath *indexPath =  [_tableView indexPathForRowAtPoint:gestureLocationInTable];
    [self.delegate resetTaskRemainingTimeAtIndexPath:indexPath];
    [self.delegate reloadData];
}
@end
