//
//  DisplayLyricView.m
//  CFMusicDemo
//
//  Created by chenfeng on 2019/2/27.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "DisplayLyricView.h"
#import "LyricCell.h"

@interface DisplayLyricView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DisplayLyricView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _textArray = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor clearColor];
        _currentRow = 0;
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (void)reloadTableViewWithCurrentRow
{
    [_tableView reloadData];
    //滚到底部就不用滚动了,不然会出现回弹的情况
    if (self.tableView.contentOffset.y < self.tableView.contentSize.height - self.frame.size.height) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_textArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    LyricCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        
        cell = [[LyricCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellIdentify];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == _currentRow)
    {
        cell.text.textColor = [UIColor redColor];
    }
    else
    {
        cell.text.textColor = [UIColor blackColor];
    }
    
    cell.text.text = _textArray[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 0.1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_textArray.count == 1) {
        return self.frame.size.width/2 - CELL_HEIGHT/2;
    }
    return 0.1;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
