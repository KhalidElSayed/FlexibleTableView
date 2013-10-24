//
//  MAFlexibleTableViewController.h
//  FlexibleTableView
//
//  Created by mohamed abd elaleem on 10/23/13.
//  Copyright (c) 2013 mohamed abd elaleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPullToAdd.h"
#import "MSPinchOutHandler.h"
#import "MSPinchInHandler.h"
#import "MSDragAndDropHandler.h"

@interface MAFlexibleTableViewController : UITableViewController <MAPullTableViewDelegate,MAPinchOutDelegate,MAPinchInHandlerDelegate,MSDragAndDropHandlerDelegate>
//@property (nonatomic,strong) IBOutlet UITableView *tableView;
@end
