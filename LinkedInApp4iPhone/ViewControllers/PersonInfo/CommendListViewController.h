//
//  CommendListViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  相关推荐页面
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface CommendListViewController : UIViewController<UITableViewDataSource,
    UITableViewDelegate>
{
    int pageType;   //0:列表样式 1:网格样式
    
    int personCount; //测试数据 表示有多少个推荐的人
}
@property (weak, nonatomic) IBOutlet UITableView *listTable;

@end
