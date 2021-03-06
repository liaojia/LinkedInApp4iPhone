//
//  PersonInfoCell.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  个人履历单条信息自定义cell
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
@class ProfileModel;
@interface PersonInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView; //头像
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;        //时间
@property (weak, nonatomic) IBOutlet UILabel *orgLabel;        //组织名称
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;      //所在地
@property (nonatomic, strong) IBOutlet UIButton *recommendButton;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;       //修改
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;       //删除

@property (nonatomic, strong) ProfileModel *model;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)initWithMode:(ProfileModel *)tModel;

- (void)adjustControlFrame;
@end
