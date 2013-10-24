//
//  MAFlexibleTableViewController.m
//  FlexibleTableView
//
//  Created by mohamed abd elaleem on 10/23/13.
//  Copyright (c) 2013 mohamed abd elaleem. All rights reserved.
//

#import "MAPinchInGestureTableViewController.h"


@interface MAPinchInGestureTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) MSPinchInHandler *pinchInTableViewHandler;


@property (nonatomic,strong) NSString *dragAndDropPlaceHolder;


@end

@implementation MAPinchInGestureTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"data 1",@"data 2",@"data 3",@"data 4",@"data 5", nil];
    
    
    
    _pinchInTableViewHandler = [[MSPinchInHandler alloc] initWithTableView:self.tableView];
    _pinchInTableViewHandler.delegate = self;
    
    
}

-(void)didPinchInAtCellIndexPath:(NSIndexPath *)indexPath
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
