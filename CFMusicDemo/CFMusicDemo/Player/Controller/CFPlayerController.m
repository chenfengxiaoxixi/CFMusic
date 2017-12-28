//
//  CFPlayerController.m
//  CFMusicDemo
//
//  Created by cf on 2017/12/23.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import "CFPlayerController.h"
#import "CFCDView.h"
#import <FSAudioStream.h>

//少司命 - 客官请进
#define MUSIC1 @"http://music.163.com/song/media/outer/url?id=444444053.mp3"
//Mike Zhou - The Dawn
#define MUSIC2 @"http://music.163.com/song/media/outer/url?id=476592630.mp3"
//Matteo - Panama
#define MUSIC3 @"http://music.163.com/song/media/outer/url?id=34229976.mp3"

@interface CFPlayerController ()

@property (nonatomic, strong) CFCDView *cdView;
// 对象
@property (nonatomic, strong) FSAudioStream *audioStream;

@end

@implementation CFPlayerController

+ (instancetype)sharePlayerController
{
    @synchronized(self)
    {
        static CFPlayerController *_instance = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
        
        return _instance;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = _model.songName;
    
    if (![CFUSER.currentSong.songId isEqualToString:_model.songId]) {
        CFUSER.currentSong = _model;
        CFUSER.currentIndex = _songAtindex;
        [self.cdView reloadNew];
        [self buildStreamer];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUserInterface];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildUserInterface
{
    weakSELF;
    
    //实例化
    self.cdView = [[CFCDView alloc] initWithFrame:CGRectMake(0,64 + 30, ScreenWidth,ROTATION_WIDTH + 80)];
    self.cdView.backgroundColor = [UIColor clearColor];
    self.cdView.isPlayer = ^(BOOL is){
        
        if (is) {
            [weakSelf.audioStream pause];
            NSLog(@"play");
        }
        else
        {
            [weakSelf.audioStream pause];
            NSLog(@"pause");
        }
        
    };
    self.cdView.scrollViewDidEndDecelerating = ^(UIScrollView *scrollView,BOOL isScrollRight) {

        if (isScrollRight) {
            [weakSelf next];
        }
        else
        {
            [weakSelf prev];
        }
    };
    [self.view addSubview:self.cdView];
    
    UIButton *prevButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    prevButton.frame = CGRectMake(ScreenWidth/2 - 40 - 50, CGRectGetMaxY(self.cdView.frame) + 80, 40, 40);
    prevButton.tintColor = [UIColor grayColor];
    [prevButton setImage:[UIImage imageNamed:@"prev"] forState:(UIControlStateNormal)];
    [prevButton cf_addEventHandler:^(UIButton *btn) {
        
        [weakSelf.cdView scrollLeftWithPrev];
        
    } forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:prevButton];
    
    UIButton *nextButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    nextButton.frame = CGRectMake(ScreenWidth/2 + 50, CGRectGetMaxY(self.cdView.frame) + 80, 40, 40);
    nextButton.tintColor = [UIColor grayColor];
    [nextButton setImage:[UIImage imageNamed:@"next"] forState:(UIControlStateNormal)];
    [nextButton cf_addEventHandler:^(UIButton *btn) {
        
        //下一首
        [weakSelf.cdView scrollRightWIthNext];
  
    } forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:nextButton];
    
}

- (void)buildStreamer
{
    weakSELF;
    // 网络文件
    NSURL *url = [NSURL URLWithString:CFUSER.currentSong.url];
    
    if (!_audioStream) {
        // 创建FSAudioStream对象
        _audioStream = [[FSAudioStream alloc] initWithUrl:url];
        _audioStream.onFailure = ^(FSAudioStreamError error,NSString *description){
            NSLog(@"播放过程中发生错误，错误信息：%@",description);
            
            [weakSelf showAlertMsg:description];
            
        };
        _audioStream.onCompletion=^(){
            
            [weakSelf.cdView scrollRightWIthNext];
        };
        
        // 设置声音
        [_audioStream setVolume:1];
        [_audioStream play];
    }
    else
    {
        _audioStream.url = url;
        [_audioStream play];
    }
}

- (void)next
{
    CFUSER.currentIndex++;
    
    [self.audioStream stop];
    
    CFStreamerModel *model =  _dataSource[ CFUSER.currentIndex > [_dataSource count]-1 ? 0 : CFUSER.currentIndex];
    
    if (CFUSER.currentIndex > [_dataSource count]-1) {
        CFUSER.currentIndex = 0;
    }
    
    CFUSER.currentSong = model;
    self.title = model.songName;
    [self buildStreamer];
    
}

- (void)prev
{
    CFUSER.currentIndex--;
    
    [self.audioStream stop];
    
    CFStreamerModel *model =  _dataSource[ CFUSER.currentIndex < 0 ? [_dataSource count]-1 : CFUSER.currentIndex];
    
    if (CFUSER.currentIndex < 0) {
        CFUSER.currentIndex = [_dataSource count] - 1;
    }
    
    CFUSER.currentSong = model;
    self.title = model.songName;
    [self buildStreamer];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
