//
//  MSUtilitiesGesturesHandler.h
//  PinchToAddCell
//
//  Created by Lion User on 10/06/2013.
//  Copyright (c) 2013 com.molased. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MSUtilitiesGestureHandlerProtocol <NSObject>

-(void)playTaskAtIndexPath:(NSIndexPath*)indexPath;
-(void)setTaskAsLastToPlayAtIndexPath:(NSIndexPath*)indexPath;
-(void)resetTaskRemainingTimeAtIndexPath:(NSIndexPath*)indexPath;
- (void)needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

-(void)showInsertionDialogAtIndex:(NSInteger)index withFrame:(CGRect)insertionFrame isEdit:(BOOL)isEdit;

-(void)increaseRemainingTimeForCellAtIndex:(NSInteger)index;
-(void)decreaseRemainingTimeForCellAtIndex:(NSInteger)index;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(BOOL)shouldStartGesture:(UIGestureRecognizer*)gestureRecognizer;
-(void)reloadData;
@end

@interface MSUtilitiesGesturesHandler : NSObject <UIGestureRecognizerDelegate>

-(id)initWithTableView:(UITableView*)tableView delegate:(id<MSUtilitiesGestureHandlerProtocol>)delegate;

@property (nonatomic,strong) id<MSUtilitiesGestureHandlerProtocol>delegate;

@end
