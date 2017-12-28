//
//  UIButton+BlockUI.h
//  zhuawawa
//
//  Created by cf on 2017/11/27.
//  Copyright © 2017年 mobilecpx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cf_ButtonEventsBlock)(UIButton *button);

@interface UIButton (BlockUI)

@property (nonatomic, copy) cf_ButtonEventsBlock cf_buttonEventsBlock;

- (void)cf_addEventHandler:(void (^)(UIButton *btn))block forControlEvents:(UIControlEvents)controlEvents;

@end
