//
//  CFUser.h
//  CFMusicDemo
//
//  Created by cf on 2017/12/28.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFStreamerModel.h"

@interface CFUser : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) CFStreamerModel *currentSong;

+ (instancetype)shareInstance;

@end
