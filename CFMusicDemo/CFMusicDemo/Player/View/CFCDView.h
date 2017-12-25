//
//  CFCDView.h
//  CFMusicDemo
//
//  Created by cf on 2017/12/23.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CFCDView : UIScrollView<UIScrollViewDelegate>

@property(nonatomic,strong) UIImageView *CDImageView;

@property(nonatomic,strong) void(^scrollViewDidEndDecelerating)(UIScrollView *scrollView);

@property(nonatomic,strong) void(^scrollViewWillBeginDragging)(void);

@property(nonatomic,strong) void(^isPlayer)(BOOL is);

- (void)next;
- (void)stopAnimation;

@end
