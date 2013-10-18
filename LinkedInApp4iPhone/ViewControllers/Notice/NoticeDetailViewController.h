//
//  NoticeDetailViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-18.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  公告详情
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface NoticeDetailViewController : UIViewController

@property (strong, nonatomic)NSString *idStr; //前一个页面传过的id
@property (strong, nonatomic)ProfileModel *detalModel;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;


@end
