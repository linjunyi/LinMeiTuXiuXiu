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
@synthesize deleteBtn;

- (void)drawRect:(CGRect)rect {
  
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self) {
        self = [super initWithFrame:frame];
        [self createDeleteBtn];
    }
    return self;
}


- (void)createDeleteBtn {
    deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 6, self.frame.size.height / 6)];
    deleteBtn.center = CGPointMake(self.frame.size.width, 0);
    [deleteBtn setImage:[UIImage imageNamed:@"delete_fork.png"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.hidden = YES;
    [self addSubview:deleteBtn];
}

- (void)deleteBtnClicked {
    if ([self.delegate respondsToSelector:@selector(deleteBtnClicked)]) {
        [self.delegate deleteBtnClicked];
    }
}

@end
