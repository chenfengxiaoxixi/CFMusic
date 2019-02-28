//
//  CFStreamerModel.h
//  CFMusicDemo
//
//  Created by cf on 2017/12/26.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFStreamerModel : NSObject

@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *songId;
@property (nonatomic, strong) NSString *imageString;
@property (nonatomic, strong) NSString *lyric;

- (id)initWithDic:(NSDictionary *)dic;

@end
