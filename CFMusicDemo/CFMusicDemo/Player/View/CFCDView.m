//
//  CFCDView.m
//  CFMusicDemo
//
//  Created by cf on 2017/12/23.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import "CFCDView.h"
#import "CFRotationView.h"

@interface CFCDView ()

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) CFRotationView *left_rotationView;
@property (nonatomic, strong) CFRotationView *center_rotationView;
@property (nonatomic, strong) CFRotationView *right_rotationView;
@property (nonatomic, assign) NSInteger currentIndex;/* 当前滑动到了哪个位置**/
@property (nonatomic, assign) NSInteger index;

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
    self.contentSize = CGSizeMake(self.width * 3, 0);
    self.bounces = NO;
    self.pagingEnabled = YES;
    self.scrollEnabled = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    //设置当前显示的位置为中间图片
    [self setContentOffset:CGPointMake(self.width, 0) animated:NO];
    [self setUI];
    
}

- (void)setUI{
    
    weakSELF
    //实现三个碟片之间的循环
    for (int i = 0; i < 3; i++) {
        
        CFRotationView *r_view = [[CFRotationView alloc] initWithFrame:CGRectMake((ScreenWidth-(ROTATION_WIDTH + 20))/2 + i * self.width, 10, ROTATION_WIDTH + 20, ROTATION_WIDTH + 20)];
        r_view.playBlock = ^(BOOL is){
            weakSelf.isPlayer(is);
        };
        
        [self addSubview:r_view];
        
        if (i == 0) {
            
            _left_rotationView = r_view;
            _left_rotationView.isPlay = NO;
        }
        else if (i == 1)
        {
            _center_rotationView = r_view;
            _center_rotationView.isPlay = YES;
        }
        else if (i == 2)
        {
            _right_rotationView = r_view;
            _right_rotationView.isPlay = NO;
        }
    }
}

- (void)reloadDiePian
{
    int leftImageIndex,rightImageIndex;
    CGPoint offset=[self contentOffset];
    if (offset.x>self.width) { //向右滑动
        _currentIndex=(_currentIndex+1)%3;
    }else if(offset.x<self.width){ //向左滑动
        _currentIndex=(_currentIndex+3-1)%3;
    }
    _center_rotationView.CDimageView.image = IMAGE_WITH_NAME(@"cdImage");
    
    //重新设置左右碟片
    leftImageIndex=(_currentIndex+3-1)%3;
    rightImageIndex=(_currentIndex+1)%3;
    _left_rotationView.CDimageView.image = nil;
    _right_rotationView.CDimageView.image = nil;
    
    if (_index == _currentIndex) {
        return;
    }
    
    _index = _currentIndex;
    //只有播放的碟片才开启动画,其余暂停
    _left_rotationView.isPlay = NO;
    _center_rotationView.isPlay = YES;
    _right_rotationView.isPlay = NO;
}

//唱针动画开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.scrollViewWillBeginDragging();
}

//唱针动画结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //重新加载
    [self reloadDiePian];
    //移动到中间
    [self setContentOffset:CGPointMake(self.width, 0) animated:NO];
        
    self.scrollViewDidEndDecelerating(self);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
