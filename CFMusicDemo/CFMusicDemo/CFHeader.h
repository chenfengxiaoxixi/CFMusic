//
//  CFHeader.h
//  CFMusicDemo
//
//  Created by cf on 2017/12/23.
//  Copyright © 2017年 chenfeng. All rights reserved.
//


#import "CFUser.h"

#define CFUSER [CFUser shareInstance]

#define ROTATION_WIDTH 300

#define CELL_HEIGHT 50

#define weakSELF typeof(self) __weak weakSelf = self;

#define CF_NOTI_CENTER [NSNotificationCenter defaultCenter]

#define IMAGE_WITH_NAME(name)   [UIImage imageNamed:[NSString stringWithFormat:@"%@",name]]

#define IMAGE_WITH_BUNDLE(name)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:[NSString stringWithFormat:@"%@",name]]]

#define IOS7  ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
#define IOS8  ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)

#define APPDELEGATE  (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
