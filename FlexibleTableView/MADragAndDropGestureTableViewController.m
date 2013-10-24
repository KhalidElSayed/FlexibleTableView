//
//  MAFlexibleTableViewController.m
//  FlexibleTableView
//
//  Created by mohamed abd elaleem on 10/23/13.
//  Copyright (c) 2013 mohamed abd elaleem. All rights reserved.
//

#import "MADragAndDropGestureTableViewController.h"


@interface MADragAndDropGestureTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;


@property (nonatomic,strong) MSDragAndDropHandler *dragAndDropHandler;
@property (nonatomic,strong) NSString *dragAndDropPlaceHolder;


@end

@implementation MADragAndDropGestureTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"data 1",@"data 2",@"data 3",@"data 4",@"data 5", nil];
    
    
    _dragAndDropHandler = [[MSDragAndDropHandler alloc] initWithTableView:self.tableView];
    _dragAndDropHandler.delegate = self;
    
}

-(BOOL)canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _dragAndDropPlaceHolder =  [_dataArray objectAtIndex:indexPath.row];
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:@""];
}

-(void)needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:_dragAndDropPlaceHolder];
}
-(void)needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *sourceString = [_dataArray objectAtIndex:sourceIndexPath.row];
    NSString *destinationString = [_dataArray objectAtIndex:destinationIndexPath.row];
    
    [_dataArray replaceObjectAtIndex:sourceIndexPath.row withObject:destinationString];
    [_dataArray replaceObjectAtIndex:destinationIndexPath.row withObject:sourceString];
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
