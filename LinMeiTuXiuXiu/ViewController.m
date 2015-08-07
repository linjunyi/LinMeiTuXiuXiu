//
//  ViewController.m
//  LinMeiTuXiuXiu
//
//  Created by lin on 15/8/7.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "ViewController.h"
#import "LinImageView.h"


@interface ViewController ()

@property (nonatomic, strong) UIScrollView *picLibrary;
@property (nonatomic, strong) UIImageView *showImageView;

@end

@implementation ViewController

@synthesize picLibrary;
@synthesize showImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMainView];
}

- (void)createMainView {
    picLibrary = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 100)];
    picLibrary.scrollEnabled = YES;
    picLibrary.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.view.backgroundColor = [UIColor colorWithRed:126/255.0 green:106/255.0 blue:102/255.0 alpha:1.0];
    NSInteger photoNum;
    for (photoNum = 0; photoNum < 100; photoNum++) {
        LinImageView *imageView = [[LinImageView alloc] initWithFrame:CGRectMake(100 * photoNum + 2, 7.5, 93, 85)];
        imageView.userInteractionEnabled = YES;
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
        [imageView addGestureRecognizer:tap];
        imageView.imageName = [NSString stringWithFormat:@"悠哉%d.jpg", photoNum + 1];
        imageView.image = [UIImage imageNamed:imageView.imageName];
        if (imageView.image == nil) {
            break;
        }
        [picLibrary addSubview:imageView];
    }
    showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, picLibrary.frame.origin.y + picLibrary.frame.size.height + 25, self.view.frame.size.width - 50, 250)];
    showImageView.backgroundColor = [UIColor clearColor];
    NSString *defaultImageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"kDefaultImage"];
    UIImage *image = [UIImage imageNamed:defaultImageName];
    if(image) {
        showImageView.image = image;
    }
    CGFloat contentWidth = photoNum * 93 > self.view.frame.size.width? photoNum * 93 + 30 : self.view.frame.size.width + 30;
    picLibrary.contentSize = CGSizeMake(contentWidth, 0);
    
    [self.view addSubview:picLibrary];
    [self.view addSubview:showImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imageViewClicked:(UIGestureRecognizer *)gesture {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    LinImageView *imageView = (LinImageView *)gesture.view;
    [userDefaults setObject:imageView.imageName forKey:@"kDefaultImage"];
    self.showImageView.image = imageView.image;
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    okButton.center = CGPointMake(self.view.center.x - 80, self.showImageView.frame.origin.y + self.showImageView.frame.size.height + 60);
    okButton.layer.cornerRadius = 8;
    okButton.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.6];
    [okButton setTitle:@"保存" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] forState:UIControlStateHighlighted];
    okButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    cancelButton.center = CGPointMake(self.view.center.x + 80, okButton.center.y);
    cancelButton.layer.cornerRadius = 8;
    cancelButton.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.6];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:okButton];
    [self.view addSubview:cancelButton];
}

#pragma mark - 隐藏状态栏

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
