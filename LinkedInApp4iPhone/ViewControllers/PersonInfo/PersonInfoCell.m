//
//  PersonInfoCell.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "PersonInfoCell.h"
#import "ProfileModel.h"
@implementation PersonInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier profileModel:(ProfileModel*)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithModel:model];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)initWithModel:(ProfileModel*)model{
    if (!model) {
        return;
    }
    NSString *timeStr = [NSString stringWithFormat:@"%@ 至 %@", model.mStime, model.mEtime];
    [_timeLabel setText:timeStr];
    [_orgLabel setText:model.mOrg];
    [_placeLabel setText:[NSString stringWithFormat:@"%@--%@", model.mProvince, model.mCity]];
    [_descLabel setText:model.mDesc];
}
@end
