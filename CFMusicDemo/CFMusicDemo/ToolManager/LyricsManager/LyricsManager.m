//
//  LyricsManager.m
//  CFMusicDemo
//
//  Created by chenfeng on 2019/2/28.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "LyricsManager.h"
#import "DisplayLyricView.h"

@interface LyricsManager ()

@end

@implementation LyricsManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _currentRow = 0;
        _textArray = [[NSMutableArray alloc] init];
        _timeArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

//拆分歌词信息，把时间和歌词分开，歌词格式【00：00：00】啊哈哈哈哈
- (void)analysisOfLyrics:(NSString *)lyrics
{
    if ([lyrics isEqualToString:@"无歌词"]) {
        [_textArray addObject:lyrics];
        return;
    }
    
    NSArray *sepArray = [lyrics componentsSeparatedByString:@"["];
    for (int i = 0; i < sepArray.count; i++) {
        NSArray *arr = [sepArray[i] componentsSeparatedByString:@"]"];
        
        if (arr.count > 1) {
            [_timeArray addObject:arr[0]];
            [_textArray addObject:arr[1]];
        }
    }
}

//在播放进度里面实时计算播放到哪段歌词
- (NSInteger)updateSelectedIndexLyricWithTime:(CGFloat )time
{
    for (int i = 0; i < _timeArray.count; i ++) {
        
        NSArray *arr = [_timeArray[i] componentsSeparatedByString:@":"];
        //分转为秒
        CGFloat seconds = [arr[0] integerValue]*60 + [arr[1] floatValue];
        
        if (time > seconds)
        {
            _currentRow = i;
        }
        else
        {
            break;
        }
    }
    
    return _currentRow;
}

- (void)clearLyricsInfo
{
    _currentRow = 0;
    [_timeArray removeAllObjects];
    [_textArray removeAllObjects];
}

#pragma mark - LyricView

- (DisplayLyricView *)configLyricViewWithFrame:(CGRect )frame
{
    _lyricView = [[DisplayLyricView alloc] initWithFrame:frame];
    _lyricView.alpha = 0;
    _lyricView.textArray = _textArray;
    
    return _lyricView;
}

- (void)reloadLyricView
{
    [_lyricView reloadTableView];
}

- (void)reloadLyricViewWithCurrentRow
{
    _lyricView.currentRow = _currentRow;
    [_lyricView reloadTableViewWithCurrentRow];
}

@end
