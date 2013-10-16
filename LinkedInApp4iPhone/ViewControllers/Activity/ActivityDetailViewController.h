//
//  ActivityDetailViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述： 官方活动详情页
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface ActivityDetailViewController : UIViewController<UITableViewDelegate,
    UITableViewDataSource>
{
    NSArray *testArray; //测试数据
}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@end
