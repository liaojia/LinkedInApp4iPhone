//
//  ActivityCell.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述： 官方活动自定义cell
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;   //活动图片
@property (weak, nonatomic) IBOutlet UILabel *desLabel;          //活动描述
//@property (weak, nonatomic) IBOutlet UILabel *titleTxtLabel;    //题目
@property (weak, nonatomic) IBOutlet UILabel *titleDetailLabel; //题目详细
@property (weak, nonatomic) IBOutlet UILabel *timeTxtLabel;     //时间
@property (weak, nonatomic) IBOutlet UILabel *timeDetailLabel;  //时间详细
@property (weak, nonatomic) IBOutlet UILabel *placeTxtLabel;    //地点
@property (weak, nonatomic) IBOutlet UILabel *placeDetailLabel; //地点详细
@property (weak, nonatomic) IBOutlet UILabel *typeTxtLabel;     //类型
@property (weak, nonatomic) IBOutlet UILabel *typeDetailLabel;  //类型详情
@property (weak, nonatomic) IBOutlet UILabel *moneyTxtLabel;    //费用
@property (weak, nonatomic) IBOutlet UILabel *moneyDetailLabel; //费用详细
@property (weak, nonatomic) IBOutlet UILabel *hostTxtLabel;     //主办方
@property (weak, nonatomic) IBOutlet UILabel *hostDetailLabel;  //主办方详细

//设置属性值
- (void)setDataWithModel:(ProfileModel*)model;
//根据赋值文字 调整子视图frame
- (void)adjuctSubFrame;

@end
