//
//  UIImage+ImageHandle.h
//  CFMusicDemo
//
//  Created by cf on 2017/12/29.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageHandle)

// 使用vImage实现图片模糊
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
