//
//  DetailInfoViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-17.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述： 信息详情页面 公用
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface DetailInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSString *listId;  //前一个页面传过来的列表项的id
@property (strong, nonatomic) NSString *typeId;  //当前页面的类型
@property (strong, nonatomic) NSMutableArray *imageArray; //保存下载的图片
@property (strong, nonatomic) NSDictionary *resultDict;
@end
