//
//  LinAnimationViewController.h
//  LinMeiTuXiuXiu
//
//  Created by lin on 15/8/10.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinAnimationViewController : UIViewController

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data;

@end

@interface LinAnimationItem : UIButton

@property (nonatomic, strong) UILabel *textLabel;

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text;

@end
