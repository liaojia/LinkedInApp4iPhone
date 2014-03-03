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
#import <QuartzCore/QuartzCore.h>
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
- (void)awakeFromNib
{
//    self.headImgView.layer.borderColor = [UIColor grayColor].CGColor;
//    self.headImgView.layer.borderWidth = 2;
//    
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

- (void)adjustControlFrame
{
    self.placeLabel.numberOfLines = 0;
    self.placeLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    self.placeLabel.frame = CGRectMake(self.placeLabel.frame.origin.x, self.placeLabel.frame.origin.y, self.placeLabel.frame.size.width, [StaticTools getLabelHeight:self.placeLabel.text defautWidth:self.placeLabel.frame.size.width defautHeight:480 fontSize:14]+3);
   
    self.orgLabel.frame = CGRectMake(self.orgLabel.frame.origin.x, self.placeLabel.frame.origin.y+self.placeLabel.frame.size.height+5, self.orgLabel.frame.size.width, 20);
    self.changeBtn.frame = CGRectMake(self.changeBtn.frame.origin.x, self.orgLabel.frame.origin.y+self.orgLabel.frame.size.height+5, self.changeBtn.frame.size.width, self.changeBtn.frame.size.height);
}
@end
