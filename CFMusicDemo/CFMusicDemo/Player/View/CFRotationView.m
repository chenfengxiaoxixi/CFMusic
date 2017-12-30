//
//  CFRotationView.m
//  CFMusicDemo
//
//  Created by cf on 2017/12/23.
//  Copyright © 2017年 chenfeng. All rights reserved.
//

#import "CFRotationView.h"

@interface CFRotationView ()

@property (strong, nonatomic) UIImageView *ro;
@property (strong, nonatomic) UIImage *onImage;
@property (strong, nonatomic) UIImage *offImage;

@end

@implementation CFRotationView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _CDimageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2 - 65, self.height/2 - 65, 130, 130)];
        //_CDimageView.image = IMAGE_WITH_NAME(@"cdImage");
        [self addSubview:_CDimageView];
        
        _ro = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, ROTATION_WIDTH, ROTATION_WIDTH)];
        _ro.image = IMAGE_WITH_NAME(@"diepian");
        [self addSubview:_ro];
        
        CGPoint center = CGPointMake(self.width / 2.0, self.height / 2.0);
        
        _onImage = [UIImage imageNamed:@"play_overCD"];
        _offImage = [UIImage imageNamed:@"pause_overCD"];
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(0,0,_onImage.size.width * 1.3, _onImage.size.height * 1.3);
        [self.btn setCenter:center];
        [self.btn setImage:_onImage forState:UIControlStateNormal];
        [self.btn addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn];
        
    }
    return self;
}

- (void)addAnimation
{
    //Rotation
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 18;
    rotationAnimation.repeatCount = FLT_MAX;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO; //No Remove
    [self.layer addAnimation:rotationAnimation forKey:@"rotation"];
    
}

- (void)playOrPause
{
    _isPlay = !_isPlay;
    
    if (self.isPlay) {
        
        [self startRotation];
        [self.btn setImage:_onImage forState:UIControlStateNormal];
        
    }else{
        [self pauseRotation];
        [self.btn setImage:_offImage forState:UIControlStateNormal];
        
    }
    _playBlock(_isPlay);
    
}

- (void)setIsPlay:(BOOL)aIsPlay{
    
    _isPlay = aIsPlay;
    
    if (self.isPlay) {
        [self start];
        
    }else{
        [self stop];
        
    }
}

- (void)startRotation{
    self.layer.speed = 1.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval pausedTime = [self.layer timeOffset];
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
    
}


- (void)pauseRotation{
    [UIView animateWithDuration:1 animations:^{
        CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.layer.speed = 0.0;
        self.layer.timeOffset = pausedTime;
    }];
    
}

- (void)start
{
    [self addAnimation];
    [self startRotation];
    [self.btn setImage:_onImage forState:UIControlStateNormal];
}

- (void)stop
{
    self.layer.speed = 0;
    [self.layer removeAllAnimations];
    [self.btn setImage:_offImage forState:UIControlStateNormal];
}

@end
