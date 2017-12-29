//
//  CFRotationView.h
//  CFMusicDemo
//
//  Created by cf on 2017/12/23.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFRotationView : UIView

@property (assign, nonatomic) BOOL isPlay;

@property (strong, nonatomic)  UIButton *btn;

@property (strong, nonatomic)   UIImageView *CDimageView;

@property (nonatomic,strong) void(^playBlock)(BOOL isPlay);

- (void)playOrPause;

@end
