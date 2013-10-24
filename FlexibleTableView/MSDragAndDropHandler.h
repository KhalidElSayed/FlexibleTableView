//
//  MSDragAndDropHandler.h
//  PinchToAddCell
//
//  Created by Lion User on 10/06/2013.
//  Copyright (c) 2013 com.molased. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSDragAndDropHandlerDelegate.h"



@interface MSDragAndDropHandler : NSObject <UIGestureRecognizerDelegate>

-(id)initWithTableView:(UITableView*)tableView;
-(void)cancelGestureProcessIfExist;
@property (nonatomic,strong) id<MSDragAndDropHandlerDelegate>delegate;
@end
