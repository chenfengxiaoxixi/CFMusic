//
//  CFCDView.m
//  CFMusicDemo
//
//  Created by cf on 2017/12/23.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import "CFCDView.h"

@interface CFCDView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) CFRotationView *left_rotationView;
@property (nonatomic, strong) CFRotationView *right_rotationView;
@property (nonatomic, assign) NSInteger currentIndex;/* 当前滑动到了哪个位置**/
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;

@property (nonatomic, assign) BOOL isScrollRight;

@end

@implementation CFCDView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setSelf];
    }
    return self;
}

- (void)setSelf
{
    self.backgroundColor = [UIColor clearColor];
    [self buildScrollView];
    [self buildDiePian];
    [self buildChangZhen];
}

- (void)buildScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.scrollView.contentSize = CGSizeMake(self.width * 3, 0);
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    //设置当前显示的位置为中间
    [self.scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
    [self addSubview:self.scrollView];
}

- (void)buildDiePian{
    
    weakSELF
    //实现三个碟片之间的循环
    for (int i = 0; i < 3; i++) {
        
        CFRotationView *r_view = [[CFRotationView alloc] initWithFrame:CGRectMake((ScreenWidth-(ROTATION_WIDTH + 20))/2 + i * self.width, self.height/2 - (ROTATION_WIDTH + 20)/2, ROTATION_WIDTH + 20, ROTATION_WIDTH + 20)];
        r_view.playBlock = ^(BOOL is){
            weakSelf.isPlayer(is);
            if (is) {
                [weakSelf startWithAnimation];
            }
            else
            {
                [weakSelf pauseWithAnimation];
            }
        };
        
        [self.scrollView addSubview:r_view];
        
        if (i == 0) {
            
            _left_rotationView = r_view;
            _left_rotationView.isPlay = NO;
        }
        else if (i == 1)
        {
            _center_rotationView = r_view;
            _center_rotationView.isPlay = NO;
        }
        else if (i == 2)
        {
            _right_rotationView = r_view;
            _right_rotationView.isPlay = NO;
        }
    }
}

- (void)buildChangZhen
{
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2+100,20, 70, 70)];
    _imageView1.image = [UIImage imageNamed:@"changzhen_2"];
    [self addSubview:_imageView1];
    
    //中间的唱针
    _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView1.x - 10, - 70, 264*0.5, 485*0.5)];
    _imageView2.image = [UIImage imageNamed:@"changzhen_1"];
    _imageView2.layer.anchorPoint = CGPointMake(1, 0.15);//锚点重设会导致x,y坐标发生偏移
    [self addSubview:_imageView2];
    CGAffineTransform transform = CGAffineTransformMakeRotation(-0.15);
    _imageView2.transform = transform;
    
    _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView1.x+5, 27, 60, 60)];
    _imageView3.image = [UIImage imageNamed:@"changzhen_3"];
    [self addSubview:_imageView3];
    
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

- (void)scrollRightWIthNext
{
    [self pauseWithAnimation];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.width, 0) animated:YES];
}
- (void)scrollLeftWithPrev
{
    [self pauseWithAnimation];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x - self.width, 0) animated:YES];
}

- (void)reloadNew
{
   //重置碟片动画
    self.center_rotationView.isPlay = NO;
    self.center_rotationView.isPlay = YES;
}

- (void)reloadDiePian
{
    int leftImageIndex,rightImageIndex;
    CGPoint offset=[self.scrollView contentOffset];
    if (offset.x>self.scrollView.width) { //向右滑动
        _isScrollRight = YES;
        _currentIndex=(_currentIndex+1)%3;
    }else if(offset.x<self.scrollView.width){ //向左滑动
        _isScrollRight = NO;
        _currentIndex=(_currentIndex+3-1)%3;
    }
    _center_rotationView.CDimageView.image = IMAGE_WITH_NAME(@"cdImage");
    
    //重新设置左右碟片
    leftImageIndex=(_currentIndex+3-1)%3;
    rightImageIndex=(_currentIndex+1)%3;
    _left_rotationView.CDimageView.image = nil;
    _right_rotationView.CDimageView.image = nil;
    
    //移动到中间
    [self.scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
    
    //确保上一动画执行
    [self performSelector:@selector(startWithAnimation) withObject:nil afterDelay:0.2];
    
    if (_index == _currentIndex) {
        return;
    }
    
    _index = _currentIndex;
    //只有播放的碟片才开启动画,其余暂停
    _left_rotationView.isPlay = NO;
    _center_rotationView.isPlay = YES;
    _right_rotationView.isPlay = NO;
    
    self.scrollViewDidEndDecelerating(self.scrollView,self.isScrollRight);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self pauseWithAnimation];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //重新加载
    [self reloadDiePian];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //重新加载
    [self reloadDiePian];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
