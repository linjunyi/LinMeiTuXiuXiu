//
//  LinImageView.h
//  LinMeiTuXiuXiu
//
//  Created by lin on 15/8/7.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinImageView : UIImageView

@property NSString *imageName;
@property NSString *imageUrl;

- (void)initWithImageView:(UIImageView *)imageView andImageName:(NSString *)name;

@end
