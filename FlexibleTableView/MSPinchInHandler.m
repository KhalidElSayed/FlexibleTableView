//
//  MSPinchToAddDelete.m
//  PinchToAddCell
//
//  Created by Lion User on 10/06/2013.
//  Copyright (c) 2013 com.molased. All rights reserved.
//

#import "MSPinchInHandler.h"
//#import "UITableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define CELL_HEIGHT 44
struct MSTouchPoints {
    CGPoint upper;
    CGPoint lower;
};
typedef struct MSTouchPoints MSTouchPoints;


@implementation MSPinchInHandler : NSObject
{
    UITableView *_tableView;
    
    MSTouchPoints _initialPoints;
    
    NSInteger cellToInsertIndex;
    
    UITableViewCell *placeHolderCell;
    UILabel *placeHolderCellForAdd;
    UITableViewCell *placeHolderPrecedingCell;
    
    NSIndexPath *_insertionIndexPath;
    
    BOOL _pinchToAddInProgress;
    BOOL _pinchToDeleteInProgress;
    BOOL _exceededRequiredSize;
    
    
    
    
}

-(id)initWithTableView:(UITableView *)tableView
{
    if(self= [super
               init])
    {
        _tableView = tableView;
        
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandler:)];
        [_tableView addGestureRecognizer:pinchGesture];
        pinchGesture.delegate = self;
        
        
    }
    return self;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(![self isAddGesture:(UIPinchGestureRecognizer*)gestureRecognizer])
        return YES;
    return NO;
}
-(struct MSTouchPoints)normalizedPointsPositionsInX:(UIPinchGestureRecognizer*)pinchGesture
{
    CGPoint pointOne = [pinchGesture locationOfTouch:0 inView:_tableView];
    CGPoint pointTwo = [pinchGesture locationOfTouch:1 inView:_tableView];
    
    
    
    if(pointOne.x > pointTwo.x)
    {
        CGPoint tempPoint = pointOne;
        pointOne = pointTwo;
        pointTwo = tempPoint;
    }
    
    
    struct MSTouchPoints touchesPositions = {pointOne,pointTwo};
    return touchesPositions;
    
}
-(struct MSTouchPoints)normalizedPointsPositions:(UIPinchGestureRecognizer*)pinchGesture
{
    CGPoint pointOne = [pinchGesture locationOfTouch:0 inView:_tableView];
    CGPoint pointTwo = [pinchGesture locationOfTouch:1 inView:_tableView];
    
    
    if(pointOne.y > pointTwo.y)
    {
        CGPoint tempPoint = pointOne;
        pointOne = pointTwo;
        pointTwo = tempPoint;
    }
    
    
    struct MSTouchPoints touchesPositions = {pointOne,pointTwo};
    return touchesPositions;
}
-(BOOL) viewContainsPoint:(UIView*)view withPoint:(CGPoint)point
{
    CGRect frame = view.frame;
    return (frame.origin.y < point.y) && ((frame.origin.y + frame.size.height) > point.y);
}
-(void)pinchGestureHandler:(UIPinchGestureRecognizer*)pinchGesure
{
    
    if(pinchGesure.state == UIGestureRecognizerStateBegan)
    {
       
            
        [self pinchDeleteStarted:pinchGesure];
        _exceededRequiredSize = NO;
        
    }else if(pinchGesure.state == UIGestureRecognizerStateChanged && pinchGesure.numberOfTouches == 2  )
    {
            [self pinchDeleteChanged:pinchGesure];
            
        
        
        
    }else if(pinchGesure.state == UIGestureRecognizerStateEnded || pinchGesure.state == UIGestureRecognizerStateCancelled)
    {
        // in case of cancelled should remove the placeholder image from the tableview
        
        
            [self pinchDeleteEnded:pinchGesure];
        
        
        
    }
    
}

-(BOOL)isAddGesture:(UIPinchGestureRecognizer*)pinchGesture
{
    return pinchGesture.scale > 1;
}



-(void)pinchDeleteStarted:(UIPinchGestureRecognizer*)pinchGesure
{
    _initialPoints = [self normalizedPointsPositionsInX:pinchGesure];
    
    NSArray *visibleCells = _tableView.visibleCells ;
    for(int i=0;i<visibleCells.count;i++)
    {
        UITableViewCell *cell = visibleCells[i];
        if([self viewContainsPoint:cell withPoint:_initialPoints.upper])
        {
            cellToInsertIndex = i;
            
            
        }
        
    }
    
    placeHolderCell = (UITableViewCell*)visibleCells[cellToInsertIndex];
    
    _pinchToDeleteInProgress = YES;
    
}
-(void)pinchDeleteChanged:(UIPinchGestureRecognizer*)pinchGesure
{
    if(!_pinchToDeleteInProgress) return;
    MSTouchPoints touchPoints = [self normalizedPointsPositionsInX:pinchGesure];
    
    CGFloat upperDelta = touchPoints.upper.x -_initialPoints.upper.x ;
    
    CGFloat lowerDelta = _initialPoints.lower.x  - touchPoints.lower.x;
    
    CGFloat delta = MIN(upperDelta, lowerDelta);
    
    CGFloat gap =  2*delta;
    
    
    
    NSArray *visibleArrays = _tableView.visibleCells;
    for(int i =0 ;i<visibleArrays.count;i++)
    {
        UIView *cellView = (UIView*)visibleArrays[i];
        if(i < cellToInsertIndex)
        {
            cellView.transform = CGAffineTransformMakeTranslation(0, MIN(delta, CELL_HEIGHT/2.0)
                                                                  );
        }else if(i > cellToInsertIndex)
        {
            cellView.transform = CGAffineTransformMakeTranslation(0,- MIN(delta, CELL_HEIGHT/2.0));
        }
        
    }
    
    
    CGFloat cellGappedSize = MAX(MIN(CELL_HEIGHT, CELL_HEIGHT-gap) , 0);
    
    placeHolderCell.transform = CGAffineTransformMakeScale(1.0f, cellGappedSize/CELL_HEIGHT);
    placeHolderCell.alpha = MIN(1, cellGappedSize/CELL_HEIGHT);
    
    _exceededRequiredSize = cellGappedSize == CELL_HEIGHT ? NO : YES ;
}


-(void)pinchDeleteEnded:(UIPinchGestureRecognizer*)pinchGesure 
{
    
    if(!_pinchToDeleteInProgress) return;
    NSIndexPath *indexPath = [_tableView indexPathForCell:placeHolderCell];
    if(_exceededRequiredSize)
    {
        [self.delegate didPinchInAtCellIndexPath:indexPath];
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self resetVisibleCellsToIdentity];
            
            placeHolderCell.transform = CGAffineTransformIdentity;
            placeHolderCell.alpha = 1;
            
            
        }];
        //[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [CATransaction commit];
        
        
    }else
    {
        [self resetVisibleCellsToIdentity];
    }
    _pinchToDeleteInProgress = NO;
}




-(void)resetVisibleCellsToIdentity
{
    NSArray *visibleCells = _tableView.visibleCells;
    for(int i=0;i<visibleCells.count;i++)
    {
        UIView *cell = visibleCells[i];
        cell.transform = CGAffineTransformIdentity;
    }
}

-(void)cancelGestureProcessIfExist
{
    if(_pinchToAddInProgress || _pinchToDeleteInProgress)
    {
        _pinchToDeleteInProgress = NO;
        _pinchToAddInProgress = NO;
        placeHolderCell.transform = CGAffineTransformMakeScale(1.0f, 0);
        placeHolderCell.alpha = 1;
        [placeHolderCell removeFromSuperview];
        [self resetVisibleCellsToIdentity];
    }
    
    
}


@end
