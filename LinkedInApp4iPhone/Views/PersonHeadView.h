//
//  PersonHeadView.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述： 头像视图 包含一张图片和名字
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface PersonHeadView : UIView

@property (strong, nonatomic) UIImageView *headImgView;     //头像图片
@property (strong, nonatomic) UILabel *nameLabel;       //名字

@end
