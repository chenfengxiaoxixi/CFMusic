//
//  CFCDView.h
//  CFMusicDemo
//
//  Created by cf on 2017/12/23.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFRotationView.h"

@interface CFCDView : UIView<UIScrollViewDelegate>

@property(nonatomic,strong) UIImageView *CDImageView;
@property (nonatomic, strong) CFRotationView *center_rotationView;

@property(nonatomic,strong) void(^scrollViewDidEndDecelerating)(UIScrollView *scrollView, BOOL isScrollRight);

@property(nonatomic,strong) void(^isPlayer)(BOOL is);

- (void)scrollRightWIthNext;
- (void)scrollLeftWithPrev;
- (void)reloadNew;
- (void)playOrPause;

@end
