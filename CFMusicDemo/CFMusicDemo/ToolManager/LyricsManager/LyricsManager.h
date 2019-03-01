//
//  LyricsManager.h
//  CFMusicDemo
//
//  Created by chenfeng on 2019/2/28.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DisplayLyricView;

@interface LyricsManager : NSObject

@property (nonatomic, strong) NSMutableArray *textArray;
@property (nonatomic, strong) NSMutableArray *timeArray;

@property (nonatomic, strong) DisplayLyricView *lyricView;

@property (nonatomic, assign) NSInteger currentRow;

- (void)analysisOfLyrics:(NSString *)lyrics;

- (NSInteger)updateSelectedIndexLyricWithTime:(CGFloat )time;

- (void)clearLyricsInfo;

- (DisplayLyricView *)configLyricViewWithFrame:(CGRect )frame;

- (void)reloadLyricView;

- (void)reloadLyricViewWithCurrentRow;

@end


