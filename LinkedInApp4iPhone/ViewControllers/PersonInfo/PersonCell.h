//
//  PersonCell.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  个人信息自定义cell
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/

#import <UIKit/UIKit.h>

@interface PersonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *headImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;        //姓名
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;         //性别
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;       //地址
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;       //操作按钮

@end
