//
//  CircleMemberListViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-29.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  圈子信息
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/

#import <UIKit/UIKit.h>

@interface CircleMemberListViewController : UIViewController
{
    int currentPage;
}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSMutableArray *resultMtbArray;
@property (strong, nonatomic) NSString *circleId;
@property (assign, nonatomic) int pageType; //0:我创建的圈子 1：我加入的圈子 2：推荐的圈子
@end
