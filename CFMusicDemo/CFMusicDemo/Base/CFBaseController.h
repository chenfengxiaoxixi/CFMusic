//
//  CFBaseController.h
//  CFMusicDemo
//
//  Created by cf on 2017/12/23.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFBaseController : UIViewController

- (void)backAction;

- (void)showLeftButtonItemWithTitle:(NSString *)title Sel:(SEL)sel;
- (void)showLeftButtonItemWithImage:(NSString *)imageName Sel:(SEL)sel;

- (void)showRightButtonItemWithTitle:(NSString *)title Sel:(SEL)sel;
- (void)showRightButtonItemWithImage:(NSString *)imageName Sel:(SEL)sel;

@end
