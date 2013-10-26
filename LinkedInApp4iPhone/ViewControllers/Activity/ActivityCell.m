//
//  ActivityCell.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "ActivityCell.h"

@implementation ActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(float)getStringHeight:(NSString*)str withFont:(UIFont*)font consSize:(CGSize)size
{
    CGSize strSize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    return strSize.height;
}

/**
 *	@brief	设置属性值
 *
 *	@param 	model 	
 */
- (void)setDataWithModel:(ProfileModel*)model
{
    self.desLabel.text =model.mDesc ;
    self.titleDetailLabel.text = model.mName;
    self.timeDetailLabel.text = model.mStime;
    self.placeDetailLabel.text = model.mPlace;
    self.typeDetailLabel.text = [NSString stringWithFormat:@"%d",[model.mType intValue]];
    self.moneyDetailLabel.text = [NSString stringWithFormat:@"%d",[model.mMoney intValue]];
    self.hostDetailLabel.text = model.mSponsor;
    [self.headImgView setImageWithURL:[NSURL URLWithString:model.mImgUrl] placeholderImage:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
    NSLog(@"acitvity.mImgUrl %@",model.mImgUrl);

}
/**
 *	@brief	根据赋值文字 调整子视图frame  需在设置了所有属性的值后调用
 */
- (void)adjuctSubFrame
{

    //self.titleTxtLabel.frame  = CGRectMake(self.titleTxtLabel.frame.origin.x, self.desLabel.frame.size.height+self.desLabel.frame.origin.y, self.titleTxtLabel.frame.size.width, self.titleTxtLabel.frame.size.height);
    
    self.titleDetailLabel.frame = CGRectMake(self.titleDetailLabel.frame.origin.x, self.titleDetailLabel.frame.origin.y, self.titleDetailLabel.frame.size.width, [self getStringHeight:self.titleDetailLabel.text withFont:[UIFont systemFontOfSize:18] consSize:CGSizeMake(self.titleDetailLabel.frame.size.width, 1000)]);
    self.desLabel.frame = CGRectMake(self.desLabel.frame.origin.x, self.titleDetailLabel.frame.origin.y+self.titleDetailLabel.frame.size.height, self.desLabel.frame.size.width, [self getStringHeight:self.desLabel.text withFont:[UIFont systemFontOfSize:15] consSize:CGSizeMake(self.desLabel.frame.size.width, 1000)]);
    
    if (self.desLabel.frame.size.height+self.desLabel.frame.origin.y>self.timeTxtLabel.frame.origin.y)
    {
        self.timeTxtLabel.frame  = CGRectMake(self.timeTxtLabel.frame.origin.x, self.desLabel.frame.size.height+self.desLabel.frame.origin.y, self.timeTxtLabel.frame.size.width, self.timeTxtLabel.frame.size.height);
    }
    else
    {
        self.timeTxtLabel.frame  = CGRectMake(self.timeTxtLabel.frame.origin.x, self.timeTxtLabel.frame.origin.y, self.timeTxtLabel.frame.size.width, self.timeTxtLabel.frame.size.height);
    }
    
    self.timeDetailLabel.frame = CGRectMake(self.timeDetailLabel.frame.origin.x, self.timeTxtLabel.frame.origin.y, self.timeDetailLabel.frame.size.width, [self getStringHeight:self.timeDetailLabel.text withFont:[UIFont systemFontOfSize:17] consSize:CGSizeMake(self.timeDetailLabel.frame.size.width, 1000)]);
    
    self.placeTxtLabel.frame  = CGRectMake(self.placeTxtLabel.frame.origin.x, self.timeDetailLabel.frame.size.height+self.timeDetailLabel.frame.origin.y, self.placeTxtLabel.frame.size.width, self.placeTxtLabel.frame.size.height);
    self.placeDetailLabel.frame = CGRectMake(self.placeDetailLabel.frame.origin.x, self.placeTxtLabel.frame.origin.y, self.placeDetailLabel.frame.size.width, [self getStringHeight:self.placeDetailLabel.text withFont:[UIFont systemFontOfSize:17] consSize:CGSizeMake(self.placeDetailLabel.frame.size.width, 1000)]);
    
    self.typeTxtLabel.frame  = CGRectMake(self.typeTxtLabel.frame.origin.x, self.placeDetailLabel.frame.size.height+self.placeDetailLabel.frame.origin.y, self.typeTxtLabel.frame.size.width, self.typeTxtLabel.frame.size.height);
    self.typeDetailLabel.frame = CGRectMake(self.typeDetailLabel.frame.origin.x, self.typeTxtLabel.frame.origin.y, self.typeDetailLabel.frame.size.width, [self getStringHeight:self.typeDetailLabel.text withFont:[UIFont systemFontOfSize:17] consSize:CGSizeMake(self.typeDetailLabel.frame.size.width, 1000)]);
    
    self.moneyTxtLabel.frame  = CGRectMake(self.moneyTxtLabel.frame.origin.x, self.typeDetailLabel.frame.size.height+self.typeDetailLabel.frame.origin.y, self.moneyTxtLabel.frame.size.width, self.moneyTxtLabel.frame.size.height);
    self.moneyDetailLabel.frame = CGRectMake(self.moneyDetailLabel.frame.origin.x, self.moneyTxtLabel.frame.origin.y, self.moneyDetailLabel.frame.size.width, [self getStringHeight:self.moneyDetailLabel.text withFont:[UIFont systemFontOfSize:17] consSize:CGSizeMake(self.moneyDetailLabel.frame.size.width, 1000)]);
    
    self.hostTxtLabel.frame  = CGRectMake(self.hostTxtLabel.frame.origin.x, self.moneyDetailLabel.frame.size.height+self.moneyDetailLabel.frame.origin.y, self.hostTxtLabel.frame.size.width, self.hostTxtLabel.frame.size.height);
    self.hostDetailLabel.frame = CGRectMake(self.hostDetailLabel.frame.origin.x, self.hostTxtLabel.frame.origin.y, self.hostDetailLabel.frame.size.width, [self getStringHeight:self.hostDetailLabel.text withFont:[UIFont systemFontOfSize:17] consSize:CGSizeMake(self.hostDetailLabel.frame.size.width, 1000)]);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.hostDetailLabel.frame.size.height+self.hostDetailLabel.frame.origin.y+5);
}

@end
