//
//  FeedOutViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-19.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述： 校友捐赠方式||数据母校  （都为写死）
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface FeedOutViewController : UIViewController
@property (assign, nonatomic)int pageType; //0：捐赠方式 1：数据母校
@property (strong, nonatomic) NSString *content;
@end
