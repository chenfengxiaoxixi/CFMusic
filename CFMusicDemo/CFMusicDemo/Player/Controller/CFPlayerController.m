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
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPRemoteCommandCenter.h>
#import <MediaPlayer/MPRemoteCommand.h>
#import <MediaPlayer/MPRemoteCommandEvent.h>
#import "CFSliderView.h"
#import "DisplayLyricView.h"
#import "LyricsManager.h"


@interface CFPlayerController ()

@property (nonatomic, strong) CFCDView *cdView;
// 对象
@property (nonatomic, strong) FSAudioStream *audioStream;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger playTime;
@property (nonatomic, assign) NSInteger totalTime;
@property (nonatomic, strong) CFSliderView *sliderView;

@property (nonatomic, strong) LyricsManager *lyricsManager;

@property (nonatomic, assign) BOOL isDisplyCDView;

@end

@implementation CFPlayerController

+ (instancetype)sharePlayerController
{
    static CFPlayerController *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = _model.songName;
    
    //从列表点击进入时，判断是否为同一首歌
    if (![CFUSER.currentSongModel.songId isEqualToString:_model.songId]) {
        CFUSER.currentSongModel = _model;
        [self.cdView reloadNew];
        [self updateInfo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //开启锁屏处理多媒体事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //开启锁屏处理多媒体事件
    [self configRemoteControlEvents];
    
    _isDisplyCDView = YES;
    
    [self buildUserInterface];
    [self buildDisplaylyricView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configRemoteControlEvents
{
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //初始化远程控制中心
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    //播放，暂停
           [commandCenter.togglePlayPauseCommand addTarget:self action:@selector(remoteControlActionWithPlayPause:)];
           //下一首
           [commandCenter.nextTrackCommand addTarget:self action:@selector(remoteControlActionWithNext:)];
           //上一首
           [commandCenter.previousTrackCommand addTarget:self action:@selector(remoteControlActionWithPre:)];
           //进度条拖动
    if (@available(iOS 9.1, *)) {
        [commandCenter.changePlaybackPositionCommand addTarget:self action:@selector(remoteControlActionSeekToPosition:)];
    } else {
        // Fallback on earlier versions
    }
    
}

#pragma mark - UI

- (UIImageView *)bg_imageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    UIImage *image = [UIImage boxblurImage:[UIImage imageNamed:@"gb_imageView"] withBlurNumber:0.8];
    
    imageView.image = image;
    
    return imageView;
}

- (void)buildUserInterface
{
    UIImageView *bg_imageView = [self bg_imageView];
    [self.view addSubview:bg_imageView];
    
    weakSELF;
    
    //实例化唱片
    self.cdView = [[CFCDView alloc] initWithFrame:CGRectMake(0,64 + 30, ScreenWidth,ROTATION_WIDTH + 80)];
    self.cdView.backgroundColor = [UIColor clearColor];
    self.cdView.isPlayer = ^(BOOL is){
        
        [weakSelf.audioStream pause];
        
        if (is) {
            [weakSelf.timer setFireDate:[NSDate distantPast]];// 计时器开始
            
            NSLog(@"play");
        }
        else
        {
            [weakSelf.timer setFireDate:[NSDate distantFuture]];// 计时器暂停
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDisplay)];
    [_cdView addGestureRecognizer:tap];
    
    //进度条
    _sliderView = [[CFSliderView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.cdView.frame) + 30, ScreenWidth - 40, 30)];
    [self.view addSubview:_sliderView];
    _sliderView.sliderValueChangeWithCallback = ^(UISlider *slider) {
      
        [weakSelf dragSliderEnd:slider];
    };
    
    //上一首
    UIButton *prevButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    prevButton.tag = 100;
    prevButton.frame = CGRectMake(ScreenWidth/2 - 40 - 50, CGRectGetMaxY(_sliderView.frame) + 40, 40, 40);
    prevButton.tintColor = [UIColor darkGrayColor];
    [prevButton setImage:[UIImage imageNamed:@"prev"] forState:(UIControlStateNormal)];
    [prevButton cf_addEventHandler:^(UIButton *btn) {
        
        //延时点击，避免重复执行
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(playAction:) object:btn];
        [self performSelector:@selector(playAction:) withObject:btn afterDelay:0.5f];
        
    } forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:prevButton];
    
    //下一首
    UIButton *nextButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    nextButton.tag = 101;
    nextButton.frame = CGRectMake(ScreenWidth/2 + 50, CGRectGetMaxY(_sliderView.frame) + 40, 40, 40);
    nextButton.tintColor = [UIColor darkGrayColor];
    [nextButton setImage:[UIImage imageNamed:@"next"] forState:(UIControlStateNormal)];
    [nextButton cf_addEventHandler:^(UIButton *btn) {
        
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(playAction:) object:btn];
        [self performSelector:@selector(playAction:) withObject:btn afterDelay:0.5f];
  
    } forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:nextButton];
    
}

//初始化歌词管理
- (void)buildDisplaylyricView
{
    if (_lyricsManager == nil) {
        //歌词管理
        _lyricsManager = [[LyricsManager alloc] init];
        
        CGRect frame = CGRectMake(0,64 + 30, ScreenWidth,ROTATION_WIDTH + 80);
        [self.view addSubview:[_lyricsManager configLyricViewWithFrame:frame]];
        
        [_lyricsManager analysisOfLyrics:CFUSER.currentSongModel.lyric];
        [_lyricsManager reloadLyricView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDisplay)];
        [_lyricsManager.lyricView addGestureRecognizer:tap];
        
    }
    else
    {
        [_lyricsManager clearLyricsInfo];
        [_lyricsManager analysisOfLyrics:CFUSER.currentSongModel.lyric];
        [_lyricsManager reloadLyricView];
    }
}

//初始化播放器
- (void)buildStreamer
{
    weakSELF;
    // 网络文件
    NSURL *url = [NSURL URLWithString:CFUSER.currentSongModel.url];
    
    if (!_audioStream) {
        
        // 创建FSAudioStream对象
        _audioStream = [[FSAudioStream alloc] initWithUrl:url];
        _audioStream.onFailure = ^(FSAudioStreamError error,NSString *description){
            NSLog(@"播放过程中发生错误，错误信息：%@",description);
            
            [weakSelf showAlertMsg:description];
            
        };
        _audioStream.onCompletion=^(){
            
            [weakSelf autoPlayNext];
        };
        
        [_audioStream preload];
        [_audioStream play];
    }
    else
    {
        if (!self.audioStream.isPlaying) {
            [_timer setFireDate:[NSDate distantFuture]];// 计时器暂停
            [_audioStream stop];
            [_audioStream playFromURL:url];
        }
        else
        {
            _audioStream.url = url;
            [_audioStream preload];
            [_audioStream play];
        }
    }
    
    self.sliderView.nowTimeLabel.text = @"--:--";
    self.sliderView.totalTimeLabel.text = @"--:--";
    
    if (!self.timer) {
        //进度条
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playerProgress) userInfo:nil repeats:YES];
    }
    else
    {
        [self.timer setFireDate:[NSDate distantPast]];// 计时器开始
    }
}

//进度控制
- (void)playerProgress
{
    FSStreamPosition position = self.audioStream.currentTimePlayed;
    
    self.playTime = round(position.playbackTimeInSeconds);//四舍五入整数值
    
    double minutes = floor(fmod(self.playTime/60.0,60.0));//返回不大于()中的最大整数值
    double seconds = floor(fmod(self.playTime,60.0));
    
    self.sliderView.nowTimeLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f",minutes, seconds];
    self.sliderView.slider.value = position.position;//播放进度

    self.totalTime = position.playbackTimeInSeconds/position.position;
    //判断分母为空时的情况
    if ([[NSString stringWithFormat:@"%f",position.position] isEqualToString:@"0.000000"]) {
       
        self.sliderView.nowTimeLabel.text = @"--:--";
        self.sliderView.totalTimeLabel.text = @"--:--";
    }
    else
    {
        double minutes2 = floor(fmod(self.totalTime/60.0,60.0));
        double seconds2 = floor(fmod(self.totalTime,60.0));
        self.sliderView.totalTimeLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f",minutes2, seconds2];
    }

    //更新正在播放选中歌词
    _lyricsManager.currentRow = [_lyricsManager updateSelectedIndexLyricWithTime:position.playbackTimeInSeconds];
    [_lyricsManager reloadLyricViewWithCurrentRow];
    
    // 更新锁屏播放进度
    [self configNowPlayingInfoCenter];
    
}

#pragma mark - Action

- (void)dragSliderEnd:(UISlider *)slider{

    //滑动到底时，播放下一曲
    if (slider.value == 1) {
        [self.cdView scrollRightWIthNext];
    }
    else
    {
        if (slider.value > 0)
        {
            //初始化一个FSStreamPosition结构体
            FSStreamPosition pos;
            //只对position赋值
            pos.position = slider.value;
            [self.audioStream seekToPosition:pos];// 到指定位置播放
        }
    }
    
}

- (void)playAction:(UIButton *)sender
{
    if (sender.tag == 100) {
        [self.cdView scrollLeftWithPrev];
    }
    else
    {
        [self.cdView scrollRightWIthNext];
    }
}

- (void)next
{
    CFUSER.currentIndex++;
    
    [self.timer setFireDate:[NSDate distantFuture]];// 计时器暂停
    [self.audioStream stop];

    CFStreamerModel *model =  _dataSource[CFUSER.currentIndex > [_dataSource count]-1 ? 0 : CFUSER.currentIndex];

    if (CFUSER.currentIndex > [_dataSource count]-1) {
        CFUSER.currentIndex = 0;
    }

    CFUSER.currentSongModel = model;
    [self updateInfo];
}

- (void)prev
{
    CFUSER.currentIndex--;
    
    [self.timer setFireDate:[NSDate distantFuture]];// 计时器暂停
    [self.audioStream stop];
    
    CFStreamerModel *model =  _dataSource[ CFUSER.currentIndex < 0 ? [_dataSource count]-1 : CFUSER.currentIndex];
    
    if (CFUSER.currentIndex < 0) {
        CFUSER.currentIndex = [_dataSource count] - 1;
    }
    
    CFUSER.currentSongModel = model;
    [self updateInfo];
}

- (void)updateInfo
{
    self.title = CFUSER.currentSongModel.songName;

    [self buildStreamer];

    [self buildDisplaylyricView];

    [self configNowPlayingInfoCenter];
    _reloadInfo();

    self.cdView.center_rotationView.CDimageView.image = IMAGE_WITH_NAME(CFUSER.currentSongModel.imageString);
}

- (void)toggleDisplay
{
    if (_isDisplyCDView) {
        
        [UIView animateWithDuration:0.3 animations:^{
           
            _lyricsManager.lyricView.alpha = 1.0;
            _cdView.alpha = 0;
        } completion:^(BOOL finished) {
            
            _isDisplyCDView = NO;
        }];

    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            _cdView.alpha = 1.0;
            _lyricsManager.lyricView.alpha = 0;
        } completion:^(BOOL finished) {
            
            _isDisplyCDView = YES;
        }];
    }
    
}


#pragma mark - 锁屏控制，接受外部事件的处理

- (MPRemoteCommandHandlerStatus)remoteControlActionSeekToPosition:(MPChangePlaybackPositionCommandEvent *)event
{
    CGFloat seekTime = event.positionTime;
    
    CGFloat value = seekTime/self.totalTime;
    FSStreamPosition pos;
    pos.position = value;
    [self.audioStream seekToPosition:pos];// 到指定位置播放
    
    if (value == 1) {
        [self autoPlayNext];
    }
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)remoteControlActionWithPlayPause:(MPRemoteCommandEvent *)event
{
    [self.cdView playOrPause];
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)remoteControlActionWithNext:(MPRemoteCommandEvent *)event
{
    [self.cdView scrollRightWIthNext];
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)remoteControlActionWithPre:(MPRemoteCommandEvent *)event
{
    [self.cdView scrollLeftWithPrev];
    return MPRemoteCommandHandlerStatusSuccess;
}

//锁屏显示信息
- (void)configNowPlayingInfoCenter
{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:CFUSER.currentSongModel.songName forKey:MPMediaItemPropertyTitle];
        
        [dict setObject:@(self.playTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        //音乐的总时间
        [dict setObject:@(self.totalTime) forKey:MPMediaItemPropertyPlaybackDuration];
        //当前歌词添加在副标题处,ios12显示格式区别于低版本的ios
        if (_lyricsManager.currentRow <= _lyricsManager.textArray.count - 1) {
            [dict setObject:_lyricsManager.textArray[_lyricsManager.currentRow] forKey:MPMediaItemPropertyAlbumTitle];
        }

        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        
    }
}

//后台播放控制
- (void)autoPlayNext{
    
    //添加后台播放任务
    UIBackgroundTaskIdentifier bgTask = 0;
    if([UIApplication sharedApplication].applicationState== UIApplicationStateBackground) {
        
        NSLog(@"后台播放");
        
       UIApplication*app = [UIApplication sharedApplication];
        
        UIBackgroundTaskIdentifier newTask = [app beginBackgroundTaskWithExpirationHandler:nil];
        
        if(bgTask!= UIBackgroundTaskInvalid) {
            
            [app endBackgroundTask: bgTask];
        }
        
        bgTask = newTask;
        [self next];
    }
    else {
        
        NSLog(@"前台播放");
        [self.cdView scrollRightWIthNext];
        
    }
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
