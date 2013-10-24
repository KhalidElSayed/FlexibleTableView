//
//  MAPullTableViewDelegate.h
//  FlexibleTableView
//
//  Created by mohamed abd elaleem on 10/23/13.
//  Copyright (c) 2013 mohamed abd elaleem. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MAPullTableViewDelegate <NSObject>

@optional
-(void)didPullDownTableView:(UITableView*)tableView;
-(void)willPullDownTableView:(UITableView*)tableView;

-(void)didPullUpTableView:(UITableView*)tableView;
-(void)willPullUpTableView:(UITableView*)tableView;

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;

@end
