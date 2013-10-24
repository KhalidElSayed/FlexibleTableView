//
//  MAFlexibleTableViewController.m
//  FlexibleTableView
//
//  Created by mohamed abd elaleem on 10/23/13.
//  Copyright (c) 2013 mohamed abd elaleem. All rights reserved.
//

#import "MAPinchOutGestureTableViewController.h"


@interface MAPinchOutGestureTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) MSPinchOutHandler *pinchOutTableViewHandler;

@property (nonatomic,strong) NSString *dragAndDropPlaceHolder;


@end

@implementation MAPinchOutGestureTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"data 1",@"data 2",@"data 3",@"data 4",@"data 5", nil];
    
    
    _pinchOutTableViewHandler = [[MSPinchOutHandler alloc] initWithTableView:self.tableView];
    _pinchOutTableViewHandler.delegate = self;
    
}

-(void)didPinchOutAtCellIndexPath:(NSIndexPath *)indexPath
{}
-(void)willPinchOutAtCellIndexPath:(NSIndexPath *)indexPath
{}

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
