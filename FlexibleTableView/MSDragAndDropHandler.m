//
//  MSDragAndDropHandler.m
//  PinchToAddCell
//
//  Created by Lion User on 10/06/2013.
//  Copyright (c) 2013 com.molased. All rights reserved.
//

#import "MSDragAndDropHandler.h"
#import <QuartzCore/QuartzCore.h>

#define CELL_SNAPSHOT_TAG 10000

@implementation MSDragAndDropHandler
{
    UITableView *_tableView;
    
    NSIndexPath *_addingIndexPath;
    UILongPressGestureRecognizer *_longPressRecognizer;
    
    NSTimer *_movingTimer;
    
    CGFloat _scrollingRate;
    UIImageView *_cellSnapshot;
    
    BOOL _dragAndDropInProcess;
    
}

-(id)initWithTableView:(UITableView *)tableView
{
    if(self= [super init])
    {
        _tableView = tableView;
        
        _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
        _longPressRecognizer.delegate = self;
        [_tableView addGestureRecognizer:_longPressRecognizer];
        
        
    }
    return self;
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;// [self.delegate shouldStartGesture:gestureRecognizer];
}
- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)recognizer {

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        
        [self dragAndDropBegin:recognizer];
                
    }  else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // While our finger moves, we also moves the snapshot imageView
        [self dragAndDropChanged:recognizer];
            
    }else if (recognizer.state == UIGestureRecognizerStateEnded) {
        // While long press ends, we remove the snapshot imageView
        [self dragAndDropEnded];
        
    }
}
-(void)dragAndDropBegin:(UILongPressGestureRecognizer*)recognizer
{
    _dragAndDropInProcess = YES;
    CGPoint location = [recognizer locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // We create an imageView for caching the cell snapshot here
    UIImageView *snapShotView = (UIImageView *)[_tableView viewWithTag:CELL_SNAPSHOT_TAG];
    
    
    if ( ! snapShotView) {
        snapShotView = [[UIImageView alloc] initWithImage:cellImage];
        snapShotView.tag = CELL_SNAPSHOT_TAG;
        [_tableView addSubview:snapShotView];
        CGRect rect = [_tableView rectForRowAtIndexPath:indexPath];
        snapShotView.frame = CGRectOffset(snapShotView.bounds, rect.origin.x, rect.origin.y);
    }
    // Make a zoom in effect for the cell
//    [UIView beginAnimations:@"zoomCell" context:nil];
//    //snapShotView.transform = CGAffineTransformMakeScale(1.1, 1.1);
//    snapShotView.center = CGPointMake(_tableView.center.x, location.y);
//    snapShotView.alpha = .3;
//    [UIView commitAnimations];

    [UIView animateWithDuration:.5 animations:^{
        snapShotView.center = CGPointMake(_tableView.center.x, location.y);
        snapShotView.alpha = .3;
    }];
    
    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.delegate needsCreatePlaceholderForRowAtIndexPath:indexPath];
    
    _addingIndexPath = indexPath;
    
    [_tableView endUpdates];
    
    // Start timer to prepare for auto scrolling
    _movingTimer = [NSTimer timerWithTimeInterval:1/8 target:self selector:@selector(scrollTable) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_movingTimer forMode:NSDefaultRunLoopMode];

}
-(void)dragAndDropChanged:(UILongPressGestureRecognizer*)recognizer
{
    if(!_dragAndDropInProcess) return;
    CGPoint location = [recognizer locationInView:_tableView];
    
    UIImageView *snapShotView = (UIImageView *)[_tableView viewWithTag:CELL_SNAPSHOT_TAG];
    snapShotView.center = CGPointMake(_tableView.center.x, location.y);
    
    CGRect rect      = _tableView.bounds;
    location = [_longPressRecognizer locationInView:_tableView];
    location.y -= _tableView.contentOffset.y;       // We needed to compensate actual contentOffset.y to get the relative y position of touch.
    
    [self updateAddingIndexPathForCurrentLocation];
    
    CGFloat bottomDropZoneHeight = _tableView.bounds.size.height / 6;
    CGFloat topDropZoneHeight    = bottomDropZoneHeight;
    CGFloat bottomDiff = location.y - (rect.size.height - bottomDropZoneHeight);
    if (bottomDiff > 0) {
        _scrollingRate = bottomDiff / (bottomDropZoneHeight / 1);
    } else if (location.y <= topDropZoneHeight) {
        _scrollingRate = -(topDropZoneHeight - MAX(location.y, 0)) / bottomDropZoneHeight;
    } else {
        _scrollingRate = 0;
    }

}
-(void)dragAndDropEnded
{
    if(!_dragAndDropInProcess) return;
    // While long press ends, we remove the snapshot imageView
    
    __block __weak UIImageView *snapShotView = (UIImageView *)[_tableView viewWithTag:CELL_SNAPSHOT_TAG];
    
    // We use _addingIndexPath directly to make sure we dropped on a valid indexPath
    // which we've already ensure while UIGestureRecognizerStateChanged
    __block __weak NSIndexPath *indexPath = _addingIndexPath;
    __block __weak UITableView *weak_tableView = _tableView;
    __block __weak UIImageView *weak_cellSnapshot = _cellSnapshot;
    __block __weak NSIndexPath *weak_addingIndexPath = _addingIndexPath;
    __block __weak MSDragAndDropHandler* weakSelf = self;
    
    // Stop timer
    [_movingTimer invalidate]; _movingTimer = nil;
    _scrollingRate = 0;
    
    [UIView animateWithDuration:.6
                     animations:^{
                         CGRect rect = [weak_tableView rectForRowAtIndexPath:indexPath];
                         //snapShotView.transform = CGAffineTransformIdentity;    // restore the transformed value
                         snapShotView.alpha = 1;
                         snapShotView.frame = CGRectOffset(snapShotView.bounds, rect.origin.x, rect.origin.y);
                     } completion:^(BOOL finished) {
                         [snapShotView removeFromSuperview];
                         
                         [weak_tableView beginUpdates];
                         [weak_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                         [weak_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                         [weakSelf.delegate needsReplacePlaceholderForRowAtIndexPath:indexPath];
                         [weak_tableView endUpdates];
                         
                         [_tableView reloadData];
                         //[self reloadVisibleRowsExceptIndexPath:indexPath];
                         // Update state and clear instance variables
                         weak_cellSnapshot = nil;
                         weak_addingIndexPath = nil;
                         
                     }];
    
    _dragAndDropInProcess = NO;
}

- (void)scrollTable {
    // Scroll tableview while touch point is on top or bottom part
    
    CGPoint location        = CGPointZero;
    // Refresh the indexPath since it may change while we use a new offset
    location  = [_longPressRecognizer locationInView:_tableView];
    
    CGPoint currentOffset = _tableView.contentOffset;
    CGPoint newOffset = CGPointMake(currentOffset.x, currentOffset.y + _scrollingRate);
    if (newOffset.y < 0) {
        newOffset.y = 0;
    } else if (_tableView.contentSize.height < _tableView.frame.size.height) {
        newOffset = currentOffset;
    } else if (newOffset.y > _tableView.contentSize.height - _tableView.frame.size.height) {
        newOffset.y = _tableView.contentSize.height - _tableView.frame.size.height;
    } else {
    }
    [_tableView setContentOffset:newOffset];
    
    if (location.y >= 0) {
        UIImageView *cellSnapshotView = (id)[_tableView viewWithTag:CELL_SNAPSHOT_TAG];
        cellSnapshotView.center = CGPointMake(_tableView.center.x, location.y);
    }
    
    [self updateAddingIndexPathForCurrentLocation];
}

- (void)updateAddingIndexPathForCurrentLocation {
    NSIndexPath *indexPath  = nil;
    CGPoint location        = CGPointZero;
    
    
    // Refresh the indexPath since it may change while we use a new offset
    location  = [_longPressRecognizer locationInView:_tableView];
    indexPath = [_tableView indexPathForRowAtPoint:location];
    
    if (indexPath && [self.delegate canMoveRowAtIndexPath:indexPath] && ! [indexPath isEqual:_addingIndexPath]) {
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_addingIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.delegate needsMoveRowAtIndexPath:_addingIndexPath toIndexPath:indexPath];
        
        _addingIndexPath = indexPath;
        
        [_tableView endUpdates];
    }
}
- (void)reloadVisibleRowsExceptIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *visibleRows = [[_tableView indexPathsForVisibleRows] mutableCopy];
    [visibleRows removeObject:indexPath];
    [_tableView reloadRowsAtIndexPaths:visibleRows withRowAnimation:UITableViewRowAnimationNone];
}
-(void)doubleLongPressGestureHandler:(UILongPressGestureRecognizer*)doubleLongPressGesture
{
    _longPressRecognizer = doubleLongPressGesture;
    [self longPressGestureRecognizer:doubleLongPressGesture withDuplication:YES];
}
- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)recognizer withDuplication:(BOOL)duplicate{
    CGPoint location = [recognizer locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
        [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // We create an imageView for caching the cell snapshot here
        UIImageView *snapShotView = (UIImageView *)[_tableView viewWithTag:CELL_SNAPSHOT_TAG];
        if ( ! snapShotView) {
            snapShotView = [[UIImageView alloc] initWithImage:cellImage];
            snapShotView.tag = CELL_SNAPSHOT_TAG;
            [_tableView addSubview:snapShotView];
            CGRect rect = [_tableView rectForRowAtIndexPath:indexPath];
            snapShotView.frame = CGRectOffset(snapShotView.bounds, rect.origin.x, rect.origin.y);
        }
        // Make a zoom in effect for the cell
        [UIView beginAnimations:@"zoomCell" context:nil];
        snapShotView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        snapShotView.center = CGPointMake(_tableView.center.x, location.y);
        [UIView commitAnimations];
        
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [self.delegate needsCreatePlaceholderForRowAtIndexPath:indexPath];
        
        _addingIndexPath = indexPath;
        
        [_tableView endUpdates];
        
        // Start timer to prepare for auto scrolling
        _movingTimer = [NSTimer timerWithTimeInterval:1/8 target:self selector:@selector(scrollTable) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_movingTimer forMode:NSDefaultRunLoopMode];
        
    }  else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // While our finger moves, we also moves the snapshot imageView
        UIImageView *snapShotView = (UIImageView *)[_tableView viewWithTag:CELL_SNAPSHOT_TAG];
        snapShotView.center = CGPointMake(_tableView.center.x, location.y);
        
        CGRect rect      = _tableView.bounds;
        CGPoint location = [_longPressRecognizer locationInView:_tableView];
        location.y -= _tableView.contentOffset.y;       // We needed to compensate actual contentOffset.y to get the relative y position of touch.
        
        [self updateAddingIndexPathForCurrentLocation];
        
        CGFloat bottomDropZoneHeight = _tableView.bounds.size.height / 6;
        CGFloat topDropZoneHeight    = bottomDropZoneHeight;
        CGFloat bottomDiff = location.y - (rect.size.height - bottomDropZoneHeight);
        if (bottomDiff > 0) {
            _scrollingRate = bottomDiff / (bottomDropZoneHeight / 1);
        } else if (location.y <= topDropZoneHeight) {
            _scrollingRate = -(topDropZoneHeight - MAX(location.y, 0)) / bottomDropZoneHeight;
        } else {
            _scrollingRate = 0;
        }
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self dragAndDropEnded];
    }
}

-(void)cancelGestureProcessIfExist
{
    if(_dragAndDropInProcess)
    {
        [self instantDragAndDropEnded];
    }
}
-(void)instantDragAndDropEnded
{
    if(!_dragAndDropInProcess) return;
    _dragAndDropInProcess = NO;
    UIImageView *snapShotView = (UIImageView *)[_tableView viewWithTag:CELL_SNAPSHOT_TAG];
    
    // Stop timer
    [_movingTimer invalidate]; _movingTimer = nil;
    _scrollingRate = 0;
    
    
    CGRect rect = [_tableView rectForRowAtIndexPath:_addingIndexPath];
    snapShotView.transform = CGAffineTransformIdentity;    // restore the transformed value
    snapShotView.frame = CGRectOffset(snapShotView.bounds, rect.origin.x, rect.origin.y);
    
    [snapShotView removeFromSuperview];
    
    
    [self.delegate needsReplacePlaceholderForRowAtIndexPath:_addingIndexPath];
    
    
    [_tableView reloadData];
    
    
    
}

@end
