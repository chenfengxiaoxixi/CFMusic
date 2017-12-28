//
//  CFUser.m
//  CFMusicDemo
//
//  Created by cf on 2017/12/28.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import "CFUser.h"

@implementation CFUser

+ (instancetype)shareInstance
{
    static CFUser *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
        
    return _instance;
}

@end
