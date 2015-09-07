//
//  LinBlowUpViewController.h
//  LinMeiTuXiuXiu
//
//  Created by lin on 15/9/7.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinBlowUpViewController : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;

- (instancetype)initWithImage:(UIImage *)image;

@end
