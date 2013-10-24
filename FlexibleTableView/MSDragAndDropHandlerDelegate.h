//
//  MSDragAndDropHandlerDelegate.h
//  FlexibleTableView
//
//  Created by mohamed abd elaleem on 10/24/13.
//  Copyright (c) 2013 mohamed abd elaleem. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSDragAndDropHandlerDelegate <NSObject>

@required
- (BOOL)canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

- (void)needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath;


//-(BOOL)shouldStartGesture:(UIGestureRecognizer*)gestureRecognizer;

@end
