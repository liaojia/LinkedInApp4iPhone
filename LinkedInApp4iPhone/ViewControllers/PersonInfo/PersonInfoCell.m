//
//  PersonInfoCell.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "PersonInfoCell.h"
#import "ProfileModel.h"
#import "CommendListViewController.h"
@implementation PersonInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)initWithMode:(ProfileModel*)tModel{
    if (!tModel) {
        return;
    }
    NSString *timeStr = [NSString stringWithFormat:@"%@ 至 %@", tModel.mStime, tModel.mEtime];
    [self.timeLabel setText:timeStr];
    [_orgLabel setText:tModel.mOrg];
    [_placeLabel setText:[NSString stringWithFormat:@"%@--%@", tModel.mProvince, tModel.mCity]];
    NSLog(@"tmode.mimgurl %@",tModel.mImgUrl);
    [self.headImgView setImageWithURL:[NSURL URLWithString:tModel.mImgUrl] placeholderImage:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
}

@end
