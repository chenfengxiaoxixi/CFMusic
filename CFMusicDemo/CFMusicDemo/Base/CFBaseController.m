//
//  CFBaseController.m
//  CFMusicDemo
//
//  Created by cf on 2017/12/23.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import "CFBaseController.h"

@interface CFBaseController ()

@end

@implementation CFBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configUIAppearance];
}

- (void)configUIAppearance
{
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    return NO;
}

#pragma mark - Method

- (void)showBackButtonItem
{
    UIImage *selectedImage=[UIImage imageNamed: @"back_button_item"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:selectedImage style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    //开启iOS7及以上的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)showDismissButtonItem
{
    UIImage *selectedImage=[UIImage imageNamed:@"back_button_item"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:selectedImage style:UIBarButtonItemStyleDone target:self action:@selector(dismissAction)];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)showLeftButtonItemWithTitle:(NSString *)title Sel:(SEL)sel
{
    [self setLeftButtonItemWithTitleName:title backgroundImageName:nil highlightedImageName:nil action:sel];
}

- (void)showLeftButtonItemWithImage:(NSString *)imageName  Sel:(SEL)sel
{
    UIImage *selectedImage=[UIImage imageNamed:imageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:selectedImage style:UIBarButtonItemStyleDone target:self action:sel];
}

- (void)showRightButtonItemWithTitle:(NSString *)title Sel:(SEL)sel
{
    [self setRightButtonItemWithTitleName:title backgroundImageName:nil highlightedImageName:nil action:sel];
}

- (void)showRightButtonItemWithImage:(NSString *)imageName  Sel:(SEL)sel
{
    UIImage *selectedImage=[UIImage imageNamed:imageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:selectedImage style:UIBarButtonItemStyleDone target:self action:sel];
}

- (void)setLeftButtonItemWithTitleName:(NSString *)titleName
                   backgroundImageName:(NSString *)backgroundImageName
                  highlightedImageName:(NSString *)highlightedImageName
                                action:(SEL)action{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:titleName style:UIBarButtonItemStyleDone target:self action:action];
    [self.navigationItem.leftBarButtonItem setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationItem.leftBarButtonItem setBackgroundImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
}

- (void)setRightButtonItemWithTitleName:(NSString *)titleName
                    backgroundImageName:(NSString *)backgroundImageName
                   highlightedImageName:(NSString *)highlightedImageName
                                 action:(SEL)action{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:titleName style:UIBarButtonItemStyleDone target:self action:action];
    [self.navigationItem.rightBarButtonItem setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationItem.rightBarButtonItem setBackgroundImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
}


- (void)showAlertMsg:(NSString *)msg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
