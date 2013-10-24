//
//  MAPinchOutDelegate.h
//  FlexibleTableView
//
//  Created by mohamed abd elaleem on 10/23/13.
//  Copyright (c) 2013 mohamed abd elaleem. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MAPinchOutDelegate <NSObject>

@optional

-(void)willPinchOutAtCellIndexPath:(NSIndexPath*)indexPath;
-(void)didPinchOutAtCellIndexPath:(NSIndexPath*)indexPath;

@end
