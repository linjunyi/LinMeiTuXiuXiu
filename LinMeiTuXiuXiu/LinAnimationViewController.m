//
//  LinAnimationViewController.m
//  LinMeiTuXiuXiu
//
//  Created by lin on 15/8/10.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "LinAnimationViewController.h"

#define Radius 100 //半径

@implementation LinAnimationViewController

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data {
    if (self) {
        self.view.frame = frame;
        self.view.layer.cornerRadius = 50;
        self.btnArray = [NSMutableArray array];
        CGFloat rotateAngle = 2 * M_PI / data.count;
        for (NSInteger i = 0; i < data.count; i++) {
            NSString *text = data[i];
            LinAnimationItem *item = [[LinAnimationItem alloc] initWithFrame:CGRectMake(0, 0, 80, 80) text:text];
            CGFloat centerX = self.view.center.x - 10 - Radius * cos(i * rotateAngle);
            CGFloat centerY = self.view.center.y - 70 - Radius * sin(i * rotateAngle);
            item.center = CGPointMake(centerX, centerY);
            CGFloat scaleValue;
            NSInteger num;
            if (i < data.count/2) {
                num = i + 1;
            }else {
                num = data.count - i -1;
            }
            scaleValue = pow(0.85, num);
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

- (void)move:(LinAnimationItem *)item {
    if ([item.titleLabel.text isEqualToString:@"灰化图"]) {
        if ([self.delegate respondsToSelector:@selector(grayImage:)]) {
            [self.delegate grayImage:nil];
        }
    }else if([item.titleLabel.text isEqualToString:@"图像切割"]) {
        if([self.delegate respondsToSelector:@selector(cutImage:)]) {
            [self.delegate cutImage:nil];
        }
    }
}

- (void)click:(LinAnimationItem *)item {
    [self move:item];
}


@end


@implementation LinAnimationItem

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text {
    if (self) {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 30;
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