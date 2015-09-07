//
//  LinAnimationViewController.m
//  LinMeiTuXiuXiu
//
//  Created by lin on 15/8/10.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "LinAnimationViewController.h"

#define Radius 90 //半径
#define ScaleFactor 0.8
#define CircleCenterX (self.view.center.x - 20)
#define CircleCenterY (self.view.center.y - 40)
#define DurationTime 1.2f

@implementation LinAnimationViewController

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data {
    if (self) {
        self.view.frame = frame;
        self.view.layer.cornerRadius = 50;
        self.btnArray = [NSMutableArray array];
        _rotateAngle = 2 * M_PI / data.count;
        _deltaAngel = _rotateAngle;
        _currentIndex = data.count - 1;
        for (NSInteger i = 0; i < data.count; i++) {
            NSString *text = data[i];
            LinAnimationItem *item = [[LinAnimationItem alloc] initWithFrame:CGRectMake(0, 0, 90, 90) text:text tag:i];
            CGFloat centerX = CircleCenterX + Radius * cos((i + 2) * _rotateAngle);
            CGFloat centerY = CircleCenterY + Radius * sin((i + 2) * _rotateAngle);
            item.center = CGPointMake(centerX, centerY);
            item.currentAngle = (i + 2) * _rotateAngle;
            CGFloat scaleValue;
            NSInteger num;
            if (i < data.count/2) {
                num = i + 1;
            }else {
                num = data.count - i - 1;
            }
            scaleValue = pow(ScaleFactor, num);
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DScale(transform, scaleValue, scaleValue, 1);
            item.layer.transform = transform;
            item.delegate = self;
            [self.view addSubview:item];
            [self.btnArray addObject:item];
        }
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return self;
}

- (void)selectItem:(LinAnimationItem *)item {
    if (item.tag == _currentIndex) {
        if ([item.titleLabel.text isEqualToString:@"灰化图"]) {
            if ([self.delegate respondsToSelector:@selector(grayImage:)]) {
                [self.delegate grayImage:nil];
            }
        }else if([item.titleLabel.text isEqualToString:@"图像切割"]) {
            if([self.delegate respondsToSelector:@selector(cutImage:)]) {
                [self.delegate cutImage:nil];
            }
        }else if([item.titleLabel.text isEqualToString:@"放大镜"]) {
            if([self.delegate respondsToSelector:@selector(expandImage:)]) {
                [self.delegate expandImage:nil];
            }
        }
        return;
    }
    NSInteger tmpIndex = item.tag > _currentIndex ? _currentIndex + 5 : _currentIndex;
    _deltaAngel = fabsf(item.tag - (float)tmpIndex) * _rotateAngle;
    self.view.superview.userInteractionEnabled = NO;
    for (NSInteger i = 0; i < self.btnArray.count; i++) {
        LinAnimationItem *animationItem = (LinAnimationItem *)[self.view viewWithTag:i];
        [animationItem.layer addAnimation:[self moveAnimation:animationItem] forKey:@"position"];
        [animationItem.layer addAnimation:[self scaleAnimation:animationItem] forKey:@"transform.scale"];
    }
    CGFloat duration = DurationTime * ((NSInteger)(_deltaAngel / _rotateAngle))/ self.btnArray.count;
    NSTimer *timer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(setItemClickEnabled) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    _currentIndex = item.tag;
}

- (void)setItemClickEnabled {
    self.view.superview.userInteractionEnabled = YES;
}

- (CAAnimation *)moveAnimation:(LinAnimationItem *)item {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, item.center.x, item.center.y);
    CGFloat beginAngle = item.currentAngle;
    CGFloat endAngle = item.currentAngle + _deltaAngel;
    CGPathAddArc(path, nil, CircleCenterX, CircleCenterY, Radius, beginAngle, endAngle, NO);
    item.currentAngle = endAngle;
    CGFloat centerX = CircleCenterX + Radius * cos(endAngle);
    CGFloat centerY = CircleCenterY + Radius * sin(endAngle);
    item.center = CGPointMake(centerX, centerY);
    animation.path = path;
    CGPathRelease(path);
    animation.duration = DurationTime * ((NSInteger)(_deltaAngel / _rotateAngle))/ self.btnArray.count;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.calculationMode = @"paced";
    return animation;
}

- (CAAnimation *)scaleAnimation:(LinAnimationItem *)item {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(item.layer.transform.m11);
    NSInteger tmpTag = ((NSInteger)(_deltaAngel / _rotateAngle) + item.tag + (self.btnArray.count - 1 - _currentIndex)) % 5;
    NSInteger scaleNum = 0;
    if (tmpTag < self.btnArray.count/2) {
        scaleNum = tmpTag + 1;
    }else {
        scaleNum = self.btnArray.count - tmpTag - 1;
    }
    
    animation.toValue = @(pow(ScaleFactor, scaleNum));
    animation.duration = DurationTime * ((NSInteger)(_deltaAngel / _rotateAngle))/ self.btnArray.count;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

- (void)click:(LinAnimationItem *)item {
    [self selectItem:item];
}


@end


@implementation LinAnimationItem

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text tag:(NSInteger)tag{
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 30;
        self.currentAngle = 0.0;
        self.tag = tag;
        [self setTitle:text forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)click {
    if([self.delegate respondsToSelector:@selector(click:)]) {
        [self.delegate click:self];
    }
}

@end