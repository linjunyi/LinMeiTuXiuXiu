//
//  LinBlowUpViewController.m
//  LinMeiTuXiuXiu
//
//  Created by lin on 15/9/7.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "LinBlowUpViewController.h"

@interface LinBlowUpViewController ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *partImageView;

@end

@implementation LinBlowUpViewController

- (instancetype)initWithImage:(UIImage *)image {
    if (self) {
        self = [super init];
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.backButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)blowUpImage:(UIPanGestureRecognizer *)panGesture {
    if(panGesture.state == UIGestureRecognizerStateEnded) {
        [self.partImageView removeFromSuperview];
        return;
    }
    [self.partImageView removeFromSuperview];
    CGPoint center = [panGesture locationInView:panGesture.view];
    CGFloat widthUnit = self.image.size.width / self.imageView.frame.size.width;
    CGFloat heightUnit = self.image.size.height / self.imageView.frame.size.height;
    CGRect rect = CGRectMake((center.x - 25) * widthUnit, (center.y - 25) * heightUnit, 50 * widthUnit, 50 * heightUnit);
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(self.image.CGImage, rect);
    UIImage *partImage = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    self.partImageView = [[UIImageView alloc] initWithFrame:CGRectMake(center.x - 50, center.y - 100, 100, 100)];
    self.partImageView.image = partImage;
    self.partImageView.layer.cornerRadius = self.partImageView.frame.size.width / 2;
    self.partImageView.clipsToBounds = YES;
    [self.imageView addSubview:self.partImageView];
}

#pragma mark - property

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 250)];
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(blowUpImage:)];
        [_imageView addGestureRecognizer:gesture];
        _imageView.image = self.image;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 60, 30)];
        _backButton.backgroundColor = [UIColor greenColor];
        _backButton.layer.cornerRadius = 15;
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

#pragma mark - 隐藏状态栏

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
