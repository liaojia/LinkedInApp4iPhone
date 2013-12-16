//
//  StudentInfoViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  校友信息
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface StudentInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSMutableArray *studentInfoMtbArray; //保存校友动态
@property (assign, nonatomic) int studentInfoTotalCount;           //校友动态总条数
@property (strong, nonatomic) NSMutableArray *noticeInfoMtbArray; //保存通知公告
@property (assign, nonatomic) int noticeInfoTotalCount;           //通知公告总条数
@end
