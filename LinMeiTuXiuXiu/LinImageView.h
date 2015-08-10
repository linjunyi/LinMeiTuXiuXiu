//
//  LinImageView.h
//  LinMeiTuXiuXiu
//
//  Created by lin on 15/8/7.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LinImageViewDelegate<NSObject>

- (void)deleteBtnClicked;

@end

@interface LinImageView : UIImageView

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) id<LinImageViewDelegate> delegate;

@end
