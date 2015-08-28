//
//  ViewController.m
//  LinMeiTuXiuXiu
//
//  Created by lin on 15/8/7.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "ViewController.h"
#import "LinImageView.h"
#import "LinAnimationViewController.h"

#define r(x) ( (int)x & 0xff)
#define g(x) ( (int)(x >> 8)  & 0xff )
#define b(x) ( (int)(x >> 16) & 0xff )
#define a(x) ( (int)(x >> 24) & 0xff )

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *picLibrary;
@property (nonatomic, strong) LinImageView *showImageView;
@property (nonatomic, strong) UIButton *imagePickerBtn;
@property (nonatomic, strong) NSMutableArray *allImageNames;
@property (nonatomic, strong) NSMutableArray *allImageArray;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) BOOL isShowMenu;

@end

@implementation ViewController

@synthesize picLibrary;
@synthesize showImageView;
@synthesize imagePickerBtn;
@synthesize allImageNames;
@synthesize allImageArray;
@synthesize tapGesture;
@synthesize isShowMenu;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMainView];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWhenShowMenu:)];
}

- (void)createMainView {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = @"喵帕斯";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.center = CGPointMake(self.view.center.x, 20);
    imagePickerBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 15, 30, 25)];
    [imagePickerBtn setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [imagePickerBtn addTarget:self action:@selector(showImagePicker) forControlEvents:UIControlEventTouchUpInside];
    
    picLibrary = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 100)];
    picLibrary.scrollEnabled = YES;
    picLibrary.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.view.backgroundColor = [UIColor colorWithRed:126/255.0 green:106/255.0 blue:102/255.0 alpha:1.0];
    
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagesDic = [NSString stringWithFormat:@"%@/Images", docDir];
    allImageArray = [NSMutableArray array];
    allImageNames = [NSMutableArray arrayWithArray:[defaultUser objectForKey:@"kAllImageNames"]];
    if (allImageNames == nil || allImageNames.count == 0) {
        allImageNames = [NSMutableArray array];
        for (NSInteger i=0; i<4; i++) {
            [allImageNames addObject:[NSString stringWithFormat:@"悠哉%ld.jpg", (long)(i+1)]];
        }
    }
    NSInteger photoNum;
    for (photoNum = 0; photoNum < allImageNames.count; photoNum++) {
        LinImageView *imageView = [[LinImageView alloc] initWithFrame:CGRectMake(100 * photoNum + 2, 7.5, 93, 85)];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
        [imageView addGestureRecognizer:tap];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewLongPress:)];
        longPress.minimumPressDuration = 1.4f;
        [imageView addGestureRecognizer:longPress];
        imageView.imageName = allImageNames[photoNum];
        UIImage *image = [UIImage imageNamed:imageView.imageName];
        if(image == nil) {
            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", imagesDic, imageView.imageName]];
        }
        imageView.image = image;
        [allImageArray addObject:imageView];
        [picLibrary addSubview:imageView];
    }
    
    showImageView = [[LinImageView alloc] initWithFrame:CGRectMake(25, picLibrary.frame.origin.y + picLibrary.frame.size.height + 25, self.view.frame.size.width - 50, 250)];
    showImageView.backgroundColor = [UIColor clearColor];
    NSString *defaultImageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"kDefaultImage"];
    UIImage *image = [UIImage imageNamed:defaultImageName];
    if(image == nil) {
        image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", imagesDic, defaultImageName]];
    }
    if (image) {
        showImageView.image = image;
    }
    CGFloat contentWidth = photoNum * 93 > self.view.frame.size.width? photoNum * 93 + 30 : self.view.frame.size.width + 30;
    picLibrary.contentSize = CGSizeMake(contentWidth, 0);
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    menuButton.center = CGPointMake(30, 28.5);
    menuButton.alpha = 0.5;
    [menuButton setImage:[UIImage imageNamed:@"menu_normal.png"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"menu_hl.png"] forState:UIControlStateHighlighted];
    [menuButton addTarget:self action:@selector(menuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [defaultUser setObject:allImageNames forKey:@"kAllImageNames"];
    [self.view addSubview:titleLabel];
    [self.view addSubview:imagePickerBtn];
    [self.view addSubview:picLibrary];
    [self.view addSubview:showImageView];
    [self.view addSubview:menuButton];
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
    [self addButtonToView];
}

- (void)menuButtonClicked {
    if (isShowMenu == NO) {
        isShowMenu = YES;
        NSArray *menuArray = @[@"灰化图", @"图像切割", @"3", @"4", @"原图"];
        CGRect frame = CGRectMake(10, 37, self.view.frame.size.width - 20, self.view.frame.size.height - 210);
        LinAnimationViewController *linController = [[LinAnimationViewController alloc] initWithFrame:frame data:menuArray];
        linController.view.tag = 1010;
        linController.delegate = self;
        [self.view addSubview:linController.view];
        [self.view addGestureRecognizer:tapGesture];
    }else {
        UIView *view = [self.view viewWithTag:1010];
        [view removeFromSuperview];
        isShowMenu = NO;
    }
}

- (void)imageViewLongPress:(UILongPressGestureRecognizer *)longPress {
    NSLog(@"长按");
}

- (void)tapWhenShowMenu:(UITapGestureRecognizer *)tap {
    UIView *view = [self.view viewWithTag:1010];
    [view removeFromSuperview];
}

- (void)addButtonToView {
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    okButton.center = CGPointMake(self.view.center.x - 80, self.showImageView.frame.origin.y + self.showImageView.frame.size.height + 60);
    okButton.layer.cornerRadius = 8;
    okButton.backgroundColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.6];
    [okButton setTitle:@"保存" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] forState:UIControlStateHighlighted];
    okButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)okButtonClicked {
    UIView *blackView = [[UIView alloc] initWithFrame:self.view.frame];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    UILabel *okLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    okLabel.backgroundColor = [UIColor clearColor];
    okLabel.text = @"保存成功! ";
    okLabel.textColor = [UIColor whiteColor];
    okLabel.textAlignment = NSTextAlignmentCenter;
    UIView *bgView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    bgView.center = self.view.center;
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    [bgView addSubview:okLabel];
    [blackView addSubview:bgView];
    
    [self.view addSubview:blackView];
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(hideView:) withObject:blackView afterDelay:1.2];
}

- (void)hideView: (UIView *)view {
    view.hidden = YES;
    [view removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}

- (void)showImagePicker {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSUserDefaults *defaultsUser = [NSUserDefaults standardUserDefaults];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    showImageView.image = image;
    NSString  *imageStr = [(NSURL *)[info objectForKey:@"UIImagePickerControllerReferenceURL"] absoluteString];
    NSArray *strArray = [imageStr  componentsSeparatedByString:@"="];
    NSString *imageName = [NSString stringWithFormat:@"%@.%@", strArray[1], strArray[2]];
    BOOL isExist = NO;
    NSInteger i = 0;
    for (i = 0; i < allImageNames.count; i++) {
        if ([allImageNames[i] isEqualToString:imageName]) {
            isExist = YES;
            break;
        }
    }
    if (isExist) {
        if (i == 0) {
            picLibrary.contentOffset = CGPointMake(0, 0);
        }else {
            if (100 * (i - 1) > picLibrary.contentSize.width - picLibrary.frame.size.width) {
                picLibrary.contentOffset = CGPointMake(picLibrary.contentSize.width - picLibrary.frame.size.width + 30, 0);
            }else {
                picLibrary.contentOffset = CGPointMake(100 * (i - 1), 0);
            }
        }
        [self addButtonToView];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    NSInteger photoNum = [allImageArray count];
    LinImageView *imageView = [[LinImageView alloc] initWithFrame:CGRectMake(100 * photoNum + 2, 7.5, 93, 85)];
    imageView.userInteractionEnabled = YES;
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
    [imageView addGestureRecognizer:tap];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewLongPress:)];
    longPress.minimumPressDuration = 1.4f;
    [imageView addGestureRecognizer:longPress];
    imageView.imageName = imageName;
    imageView.image = image;
    [allImageNames addObject:imageView.imageName];
    [defaultsUser setObject:allImageNames forKey:@"kAllImageNames"];
    [allImageArray addObject:imageView];
    [picLibrary addSubview:imageView];
    picLibrary.contentSize = CGSizeMake(picLibrary.contentSize.width + 100, 0);
    picLibrary.contentOffset = CGPointMake(picLibrary.contentSize.width - picLibrary.frame.size.width, 0);
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagesDic = [NSString stringWithFormat:@"%@/Images", docDir];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:imagesDic]) {
        [fm createDirectoryAtPath:imagesDic withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", imagesDic, imageView.imageName];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [fm createFileAtPath:imagePath contents:imageData attributes:nil];
    [self addButtonToView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ImageProcessingDelegate

- (void)grayImage:(UIImage *)image {
    if (image == nil) {
        image = showImageView.image;
    }
    
    int bitmapInfo = kCGImageAlphaNone;
    int width = image.size.width;
    int height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), image.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    self.showImageView.image = grayImage;
}



- (void)cutImage:(UIImage *)image {
    if (image == nil) {
        image = showImageView.image;
    }
    NSUInteger bitsPerComponent = 8;
    NSUInteger bytesPerPixel = 4;
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
    void *imageData = (void *) calloc(image.size.width * image.size.height, 4);
    CGContextRef context = CGBitmapContextCreate(imageData,
                                                 image.size.width,
                                                 image.size.height,
                                                 bitsPerComponent,
                                                 bytesPerPixel * image.size.width,
                                                 colorRef,
                                                 kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0,image.size.width, image.size.height), image.CGImage);
    int *pixelsData = (int *)imageData;
    int pixelsNum = image.size.width * image.size.height;
    double averageGrayValue = 0.0;
    double maxVariance = -1;
    double grayValue = 0;
    for (NSInteger i = 0; i < pixelsNum; i++) {
        int color = *pixelsData;
        int newPixel = (r(color) + g(color) + b(color))/3;
        color = (color & 0xff000000) + (newPixel + (newPixel << 8) + (newPixel << 16));
        *pixelsData = color;
        averageGrayValue += (double)(newPixel) / pixelsNum;
        pixelsData ++ ;
    }
    for (NSInteger i = 0; i < 256; i += 11) {
        int *pixelsData = (int *)imageData;
        double targetAveGary = 0.0;
        double targetPixelNum = 0;
        double bgAveGary = 0.0;
        double bgPixelNum = 0;
        for (NSInteger j = 0; j < pixelsNum; j++) {
            int color = *pixelsData;
            int newPixel = (r(color) + g(color) + b(color))/3;
            if (newPixel < i) {
                targetAveGary += newPixel;
                targetPixelNum ++;
            }else {
                bgAveGary += newPixel;
                bgPixelNum ++;
            }
            pixelsData ++;
        }
        targetAveGary /= targetPixelNum;
        bgAveGary /= bgPixelNum;
        double variance = (targetPixelNum/pixelsNum) * pow((targetAveGary - averageGrayValue), 2) + (bgAveGary/pixelsNum) * pow((bgAveGary - averageGrayValue), 2);
        if (variance > maxVariance) {
            maxVariance = variance;
            grayValue = i;
        }
    }
    pixelsData = (int *)imageData;
    for (NSInteger i = 0; i < pixelsNum; i++) {
        int color = *pixelsData;
        int newPixel = (r(color) + g(color) + b(color))/3;
        if (newPixel > grayValue) {
            if (newPixel < 3 * grayValue / 2) {
                newPixel = 175;
            }else {
                newPixel = 245;
            }
        }else {
            newPixel = 30;
        }
        color = (color & 0xff000000) + (newPixel + (newPixel << 8) + (newPixel << 16));
        *pixelsData = color;
        pixelsData ++ ;
    }
    
    UIImage *cutImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGColorSpaceRelease(colorRef);
    CGContextRelease(context);
    self.showImageView.image = cutImage;
}

#pragma mark - 隐藏状态栏

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
