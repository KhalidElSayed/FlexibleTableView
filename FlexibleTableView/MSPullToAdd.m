//
//  MSPullToAdd.m
//  Day Player v1.1 new design
//
//  Created by Lion User on 18/06/2013.
//  Copyright (c) 2013 com.molased. All rights reserved.
//

#import "MSPullToAdd.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (UIImageColoring)

- (UIImage *)imageWithOverlayColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    if (UIGraphicsBeginImageContextWithOptions) {
        CGFloat imageScale = 1.0f;
        if ([self respondsToSelector:@selector(scale)])  // The scale property is new with iOS4.
            imageScale = self.scale;
        UIGraphicsBeginImageContextWithOptions(self.size, NO, imageScale);
    }
    else {
        UIGraphicsBeginImageContext(self.size);
    }
    
    [self drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end

@implementation MSPullToAdd
{
    // the table which this class extends and adds behaviour to
    UITableView* _tableView;
    
    // indicates the state of this behaviour
    BOOL _pullDownInProgress;
    
    // a cell which is rendered as a placeholder to indicate where a new item is added
    //UITableViewCell* _placeholderCell;
    UILabel* _placeholderCellAbove;
    UILabel* _placeholderCellUnder;
    //UIImageView *_placeholderCell;
    UITableViewCell* _firstCell;
    
    NSInteger _placeholderCellHeight;
    CGFloat cellGappedSizeAbove;
    CGFloat cellGappedSizeUnder;
    
    CGFloat _tableContentHeight;
    
    UIImageView *_tableViewBackgroundView;
}

-(id)initWithTableView:(UITableView *)tableView
{
    if(self = [super init])
    {
        
        //_placeholderCell.backgroundColor = [UIColor redColor];
        
        _tableView = tableView;
        _tableView.delegate = self;
        
        _placeholderCellHeight = 44;
    }
    return self;
}
-(UILabel*)createDraggableLabel
{
    UILabel *label = [[UILabel alloc ] init];
    label.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textColor = [UIColor lightGrayColor];
    
    return label;

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    // this behaviour starts when a user pulls down while at the top of the table
    _pullDownInProgress = scrollView.contentOffset.y <= 0.0f;
    _firstCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    _placeholderCellAbove = [self createDraggableLabel];
    _placeholderCellUnder = [self createDraggableLabel];

    _placeholderCellAbove.frame = CGRectMake(0, -_placeholderCellHeight/2,_tableView.frame.size.width, _placeholderCellHeight);
    _placeholderCellAbove.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
    
    // 65 is the cell height
   _tableContentHeight  = _tableView.contentSize.height; //= [self.delegate tableView:_tableView numberOfRowsInSection:0]*65;
    
    _placeholderCellUnder.frame = CGRectMake(0, _tableContentHeight-_placeholderCellHeight/2,_tableView.frame.size.width, _placeholderCellHeight);
    _placeholderCellUnder.layer.anchorPoint = CGPointMake(0.5f, 0.0f);
    
    cellGappedSizeAbove = 0;
    cellGappedSizeUnder = 0;
    
    //if (_pullDownInProgress)
    {
        [_tableView insertSubview:_placeholderCellAbove atIndex:0];
        [_tableView insertSubview:_placeholderCellUnder atIndex:0];
        
        _tableViewBackgroundView =  (UIImageView*)_tableView.backgroundView;
        [UIView animateWithDuration:1 animations:^{
            _tableViewBackgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            _tableView.backgroundView = nil;
        }];
        
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffsetThreshold = _tableContentHeight < _tableView.frame.size.height ? 0 : _tableContentHeight-_tableView.frame.size.height;
    
    {
        cellGappedSizeAbove = MIN(-scrollView.contentOffset.y,_placeholderCellHeight);
        cellGappedSizeUnder = MIN(scrollView.contentOffset.y - yOffsetThreshold, _placeholderCellHeight);
        
        _placeholderCellAbove.text = cellGappedSizeAbove == _placeholderCellHeight ?
        @"  Release!" : @"  Pull down to add";
        
        _placeholderCellUnder.text = cellGappedSizeUnder == _placeholderCellHeight?
        @"  Release!" : @"  Pull up to add";
        
        
        
        _placeholderCellAbove.transform = CGAffineTransformMakeScale(1.0f, cellGappedSizeAbove/_placeholderCellHeight);
        _placeholderCellUnder.transform = CGAffineTransformMakeScale(1.0f, cellGappedSizeUnder/_placeholderCellHeight);
        
        _placeholderCellAbove.alpha = MIN(1.0f, cellGappedSizeAbove / _placeholderCellHeight);
        _placeholderCellUnder.alpha = MIN(1.0f, cellGappedSizeUnder / _placeholderCellHeight);
    }
    //else
    {
        _pullDownInProgress = false;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_placeholderCellAbove removeFromSuperview];
    [_placeholderCellUnder removeFromSuperview];
    
    if (cellGappedSizeAbove >= _placeholderCellHeight)
    {
        [self.delegate didPullDownTableView:_tableView];
    }else if(cellGappedSizeUnder >= _placeholderCellHeight)
    {
        [self.delegate didPullUpTableView:_tableView];
    }
    [UIView animateWithDuration:1 animations:^{
        _tableViewBackgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        _tableView.backgroundView = _tableViewBackgroundView;
    }];
    
}
-(void)cancelGestureProcessIfExist
{
    
}
@end
