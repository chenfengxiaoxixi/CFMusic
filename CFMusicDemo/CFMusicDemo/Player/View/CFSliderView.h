//
//  CFSliderView.h
//  CFMusicDemo
//
//  Created by cf on 2017/12/31.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFSliderView : UIView

@property (nonatomic, strong) UILabel *nowTimeLabel;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) void (^sliderValueChangeWithCallback)(UISlider *slider);

@end
