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

//抓取的网易云音乐链接

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
    
    self.title = @"音乐列表";
     self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
   
    //导航栏透明效果
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self configDataSource];
    [self buildUserInterface];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configDataSource
{
    // 数据源
    _list = [[NSMutableArray alloc]init];
    
    NSArray *arr = @[@{@"url":MUSIC1,@"songName":@"少司命 - 客官请进",@"id":@"1",@"image":@"cdImage"},
                     @{@"url":MUSIC2,@"songName":@"Mike Zhou - The Dawn",@"id":@"2",@"image":@"cdImage2"},
                     @{@"url":MUSIC3,@"songName":@"Matteo - Panama",@"id":@"3",@"image":@"cdImage3"}];
    
    for (NSDictionary *dic in arr) {
        CFStreamerModel *model = [[CFStreamerModel alloc]initWithDic:dic];
        [_list addObject:model];
    }
    
}

- (void)buildUserInterface
{
    UIImageView *bg_imageView = [self bg_imageView];
    [self.view addSubview:bg_imageView];
    
    [self.view addSubview:self.tableView];
}

- (UIImageView *)bg_imageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    imageView.image = [UIImage imageNamed:@"gb_imageView"];
    
    return imageView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenHeight) style:(UITableViewStyleGrouped)];
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
        cell.backgroundColor = [UIColor clearColor];
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
    vc.songAtindex = indexPath.row;
    [self.navigationController pushViewController:vc animated:vc];
    
    vc.reloadInfo = ^{
        [self.tableView reloadData];
    };

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20 + 64;
}

@end
