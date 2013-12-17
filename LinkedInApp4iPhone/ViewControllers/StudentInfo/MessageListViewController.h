//
//  MessageListViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-17.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述： 信息列表页面 公用
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface MessageListViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIScrollView *headSclView;
@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *headPageControl;
@property (assign, nonatomic) int  type;  //页面类型 前一个页面传过来
@property (strong, nonatomic) NSMutableArray *topInfoMtbArray; //置顶列表信息
@property (strong, nonatomic) NSMutableArray *listInfoMtbArray; //页面列表信息
@end
