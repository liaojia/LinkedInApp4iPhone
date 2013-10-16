//
//  PersonInfoViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  个人履历页面 根据pageType复用   0：有关注信息 1：无关注信息
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface PersonInfoViewController : UIViewController<UITableViewDataSource,
    UITableViewDelegate>
{
    int myNoticeListType; //个人关注列表展示类型 0：列表 1：网格
    int NoticeMeListType; //关注我的列表展示类型 0：列表 1：网格
    
    int myNoticeCount;  //测试数据 我的关注人数
    int NoticeMeCount;  //测试数据 关注我的人人数
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (assign, nonatomic) int pageType;  //页面复用标志

@end
