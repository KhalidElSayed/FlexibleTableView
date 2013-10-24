//
//  MSPinchToAddDelete.h
//  PinchToAddCell
//
//  Created by Lion User on 10/06/2013.
//  Copyright (c) 2013 com.molased. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPinchOutDelegate.h"

//@protocol MSPinchToAddDeleteProtocol <NSObject>
//
//-(void)deleteItemAtIndex:(NSInteger)index ;
//
//-(BOOL)shouldStartGesture:(UIGestureRecognizer*)gestureRecognizer;
//-(void)reloadData;
//
//@end

@interface MSPinchOutHandler : NSObject <UIGestureRecognizerDelegate>

-(id)initWithTableView:(UITableView*)tableView;

-(void)cancelGestureProcessIfExist;
@property (nonatomic,strong) id<MAPinchOutDelegate> delegate;
@end
