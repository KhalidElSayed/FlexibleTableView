//
//  MAPinchInHandlerDelegate.h
//  FlexibleTableView
//
//  Created by mohamed abd elaleem on 10/23/13.
//  Copyright (c) 2013 mohamed abd elaleem. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MAPinchInHandlerDelegate <NSObject>

-(void)willPinchInAtCellIndexPath:(NSIndexPath*)indexPath;
-(void)didPinchInAtCellIndexPath:(NSIndexPath*)indexPath;

@end
