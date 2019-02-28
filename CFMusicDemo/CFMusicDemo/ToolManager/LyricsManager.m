//
//  LyricsManager.m
//  CFMusicDemo
//
//  Created by chenfeng on 2019/2/28.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "LyricsManager.h"

@implementation LyricsManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _textArray = [[NSMutableArray alloc] init];
        _timeArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

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

- (NSInteger)updateSelectedIndexLyricWithTime:(CGFloat )time
{
    NSInteger currentRow = 0;
    
    for (int i = 0; i < _timeArray.count; i ++) {
        
        NSArray *arr = [_timeArray[i] componentsSeparatedByString:@":"];
        
        CGFloat compTime = [arr[0] integerValue]*60 + [arr[1] floatValue];
        
        if (time > compTime)
        {
            currentRow = i;
        }
        else
        {
            break;
        }
    }
    
    return currentRow;
}

- (void)clearLyricsInfo
{
    [_timeArray removeAllObjects];
    [_textArray removeAllObjects];
}

@end
