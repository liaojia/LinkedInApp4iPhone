//
//  ActivityListViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-19.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述： 官方活动列表
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface ActivityListViewController : UIViewController<UITableViewDataSource,
    UITableViewDelegate>
{
    int activityTotalCount; //活动总数
    int currentPage; //当前页
}
@property (weak, nonatomic) IBOutlet UITableView *listTableVew;
@property (strong, nonatomic) NSMutableArray *listMtbArray;

@end
