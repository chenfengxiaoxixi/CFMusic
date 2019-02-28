//
//  CFPlayerController.h
//  CFMusicDemo
//
//  Created by cf on 2017/12/23.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import "CFBaseController.h"

@interface CFPlayerController : CFBaseController

// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) CFStreamerModel *model;

@property (nonatomic, strong) void (^reloadInfo)(void);

+ (instancetype)sharePlayerController;

@end
