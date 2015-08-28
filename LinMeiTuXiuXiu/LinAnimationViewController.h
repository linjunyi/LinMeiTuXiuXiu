//
//  LinAnimationViewController.h
//  LinMeiTuXiuXiu
//
//  Created by lin on 15/8/10.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface LinAnimationViewController : UIViewController

@property (nonatomic, strong) id<ImageProcessingDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, assign) CGFloat rotateAngle;
@property (nonatomic, assign) CGFloat deltaAngel;
@property (nonatomic, assign) NSInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data;

@end

@interface LinAnimationItem : UIButton

@property (nonatomic, strong) id delegate;
@property (nonatomic, assign) CGFloat currentAngle;

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text tag:(NSInteger)tag;

@end