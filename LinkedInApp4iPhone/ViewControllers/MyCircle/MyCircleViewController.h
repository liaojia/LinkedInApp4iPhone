//
//  MyCircleViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-28.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  我的圈子首页
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface MyCircleViewController : UIViewController
{
    int currentPage;
    int listTotalCount;
    int operateType;   //0:我加入的圈子 1：我创建的圈子 2：推荐的圈子
}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) NSMutableArray *resultMtbArray;
- (IBAction)buttonClickHandle:(id)sender;
//刷新我创建的圈子
- (void)refreshMyCreateCricle;
@end
