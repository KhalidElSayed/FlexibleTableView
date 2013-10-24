//
//  MSPullToAdd.h
//  Day Player v1.1 new design
//
//  Created by Lion User on 18/06/2013.
//  Copyright (c) 2013 com.molased. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPullTableViewDelegate.h"

@interface MSPullToAdd : NSObject <UITableViewDelegate>

- (id)initWithTableView:(UITableView*)tableView;
@property (nonatomic,strong) id<MAPullTableViewDelegate> delegate;

@end
