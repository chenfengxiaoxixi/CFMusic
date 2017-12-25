//
//  CFPlayerController.m
//  CFMusicDemo
//
//  Created by cf on 2017/12/23.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import "CFPlayerController.h"
#import "CFCDView.h"

@interface CFPlayerController ()

@property (nonatomic, strong) CFCDView *cdView;

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;

@end

@implementation CFPlayerController

+ (instancetype)sharePlayerController
{
    @synchronized(self)
    {
        static CFPlayerController *_instance = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
        
        return _instance;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUserInterface];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildUserInterface
{
    weakSELF;
    
    //实例化
    self.cdView = [[CFCDView alloc]initWithFrame:CGRectMake(0,64 + 80, ScreenWidth,ROTATION_WIDTH + 40)];
    self.cdView.isPlayer = ^(BOOL is){
        
        if (is) {
            
            [weakSelf startWithAnimation];
        }
        else
        {
            [weakSelf pauseWithAnimation];
        }
        
    };
    self.cdView.scrollViewWillBeginDragging = ^{
        [weakSelf pauseWithAnimation];
    };
    self.cdView.scrollViewDidEndDecelerating = ^(UIScrollView *scrollView) {
        //确保begin方法执行完
        [weakSelf performSelector:@selector(startWithAnimation) withObject:nil afterDelay:0.2];
    };
    [self.view addSubview:self.cdView];
    
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/2+100,64 + 60, 70, 70)];
    _imageView1.image = [UIImage imageNamed:@"changzhen_2"];
    [self.view addSubview:_imageView1];
    
    //中间的唱针
    _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView1.x - 10,64 - 30, 264*0.5, 485*0.5)];
    _imageView2.image = [UIImage imageNamed:@"changzhen_1"];
    _imageView2.layer.anchorPoint = CGPointMake(1, 0.15);//锚点重设会导致x,y坐标发生偏移
    [self.view addSubview:_imageView2];
    CGAffineTransform transform = CGAffineTransformMakeRotation(-0.15);
    _imageView2.transform = transform;
    
    _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView1.x+5,64 + 67, 60, 60)];
    _imageView3.image = [UIImage imageNamed:@"changzhen_3"];
    [self.view addSubview:_imageView3];
    
}

//唱针动画
- (void)pauseWithAnimation {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(-0.4);
        _imageView2.transform = transform;
        
        } completion:^(BOOL finished) {
        
    }];
     
}

- (void)startWithAnimation
{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(-0.15);
        _imageView2.transform = transform;
        } completion:^(BOOL finished) {
    
    }];
    
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
