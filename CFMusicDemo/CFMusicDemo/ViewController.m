//
//  ViewController.m
//  CFMusicDemo
//
//  Created by cf on 2017/12/23.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import "ViewController.h"
#import "CFPlayerController.h"
#import "CFUser.h"

//歌曲来自网易云

//少司命 - 客官请进
#define MUSIC1 @"http://music.163.com/song/media/outer/url?id=444444053.mp3"
//Mike Zhou - The Dawn
#define MUSIC2 @"http://music.163.com/song/media/outer/url?id=476592630.mp3"
//Matteo - Panama
#define MUSIC3 @"http://music.163.com/song/media/outer/url?id=34229976.mp3"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *list;
@property  (nonatomic, strong) UITableView *tableView;
@property  (nonatomic, strong) CFPlayerController *playerController;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"音乐列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 数据源（三首歌）
    _list = [[NSMutableArray alloc]init];
    
    NSArray *arr = @[@{@"url":MUSIC1,@"songName":@"少司命 - 客官请进",@"id":@"1"},
                                @{@"url":MUSIC2,@"songName":@"Mike Zhou - The Dawn",@"id":@"2"},
                                @{@"url":MUSIC3,@"songName":@"Matteo - Panama",@"id":@"3"}];
    
    for (NSDictionary *dic in arr) {
        CFStreamerModel *model = [[CFStreamerModel alloc]initWithDic:dic];
        [_list addObject:model];
    }
    [self.view addSubview:self.tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenHeight - 64) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = YES;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellIdentify];
    }
    
    CFStreamerModel*model =_list[indexPath.row];
    
    cell.textLabel.text = model.songName;
    
    if ([CFUSER.currentSong.songId isEqualToString:model.songId]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
        imageView.frame = CGRectMake(0, 0, 25, 25);
        cell.accessoryView = imageView;
        
    }
    else
    {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CFStreamerModel*model =_list[indexPath.row];
    
    //创建单例播放器
    CFPlayerController *vc = [CFPlayerController sharePlayerController];
    vc.model = model;
    vc.dataSource = _list;
    [self.navigationController pushViewController:vc animated:vc];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

@end
