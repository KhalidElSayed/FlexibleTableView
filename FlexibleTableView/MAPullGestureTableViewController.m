//
//  MAFlexibleTableViewController.m
//  FlexibleTableView
//
//  Created by mohamed abd elaleem on 10/23/13.
//  Copyright (c) 2013 mohamed abd elaleem. All rights reserved.
//

#import "MAPullGestureTableViewController.h"


@interface MAPullGestureTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) MSPullToAdd *pullTableViewHandler;

@end

@implementation MAPullGestureTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"data 1",@"data 2",@"data 3",@"data 4",@"data 5", nil];
    
    
    _pullTableViewHandler = [[MSPullToAdd alloc] initWithTableView:self.tableView];
    _pullTableViewHandler.delegate = self;
    
    
}
-(void)didPullDownTableView:(UITableView *)tableView
{
}
-(void)didPullUpTableView:(UITableView *)tableView
{
    
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

@end
