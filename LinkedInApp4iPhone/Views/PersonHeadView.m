//
//  PersonHeadView.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "PersonHeadView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PersonHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1;
       [self initSubView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)initSubView
{
    self.headImgView = [[UIImageView alloc]init];
    self.headImgView.frame = CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-40);
    self.headImgView.layer.borderWidth = 2;
    self.headImgView.layer.borderColor = [UIColor grayColor].CGColor;
    [self addSubview:self.headImgView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.frame.size.height-30, self.frame.size.width-10, 30)];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:20];
    self.nameLabel.textColor = RGBACOLOR(0, 140, 207, 1);
    self.nameLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:self.nameLabel];
    
}

@end
