//
//  MAFlexibleTableViewController.m
//  FlexibleTableView
//
//  Created by mohamed abd elaleem on 10/23/13.
//  Copyright (c) 2013 mohamed abd elaleem. All rights reserved.
//

#import "MAFlexibleTableViewController.h"


@interface MAFlexibleTableViewController ()

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) MSPullToAdd *pullTableViewHandler;
@property (nonatomic,strong) MSPinchOutHandler *pinchOutTableViewHandler;

@property (nonatomic,strong) MSDragAndDropHandler *dragAndDropHandler;
@property (nonatomic,strong) MSPinchInHandler *pinchInTableViewHandler;


@property (nonatomic,strong) NSString *dragAndDropPlaceHolder;


@end

@implementation MAFlexibleTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"data 1",@"data 2",@"data 3",@"data 4",@"data 5", nil];
    
    
    _pullTableViewHandler = [[MSPullToAdd alloc] initWithTableView:self.tableView];
    _pullTableViewHandler.delegate = self;
    
    _pinchOutTableViewHandler = [[MSPinchOutHandler alloc] initWithTableView:self.tableView];
    _pinchOutTableViewHandler.delegate = self;
    
    _pinchInTableViewHandler = [[MSPinchInHandler alloc] initWithTableView:self.tableView];
    _pinchInTableViewHandler.delegate = self;
    
    _dragAndDropHandler = [[MSDragAndDropHandler alloc] initWithTableView:self.tableView];
    _dragAndDropHandler.delegate = self;
    
}

-(void)didPinchOutAtCellIndexPath:(NSIndexPath *)indexPath
{}
-(void)willPinchOutAtCellIndexPath:(NSIndexPath *)indexPath
{}

-(void)didPullDownTableView:(UITableView *)tableView
{
}
-(void)didPullUpTableView:(UITableView *)tableView
{
    
}
-(void)didPinchInAtCellIndexPath:(NSIndexPath *)indexPath
{
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
