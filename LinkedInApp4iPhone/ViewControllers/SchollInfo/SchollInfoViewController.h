//
//  SchollInfoViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述： 母校动态
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/

#import <UIKit/UIKit.h>

@interface SchollInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSMutableArray *schoolInfoMtbArray; //保存母校动态信息
@property (strong, nonatomic) UIButton *schollImgbtn;  //印象首师显示图片
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSMutableArray *imgInfoArray; //印象首页图片地址数据
@property (strong, nonatomic) NSMutableArray *imgArray; //印象首师图片数据
@end
