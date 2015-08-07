//
//  LinImageView.m
//  LinMeiTuXiuXiu
//
//  Created by lin on 15/8/7.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "LinImageView.h"

@implementation LinImageView

@synthesize imageName;
@synthesize imageUrl;

- (void)drawRect:(CGRect)rect {
  
}

- (void)initWithImageView:(UIImageView *)imageView andImageName:(NSString *)name{
    if(self) {
        self.image = imageView.image;
        self.imageName = name;
    }
}

@end
