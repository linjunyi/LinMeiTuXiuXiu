//
//  ViewController.h
//  LinMeiTuXiuXiu
//
//  Created by lin on 15/8/7.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageProcessingDelegate <NSObject>

- (void)grayImage:(UIImage *)image;
- (void)cutImage:(UIImage *)image;

@end

@interface ViewController : UIViewController < UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate,
                                               ImageProcessingDelegate >


@end

