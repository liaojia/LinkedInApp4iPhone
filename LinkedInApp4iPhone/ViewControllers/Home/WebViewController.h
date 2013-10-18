//
//  WebViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-17.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  webview页面
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (strong, nonatomic) NSString *urlStr;       //请求url
@property (strong, nonatomic) NSString *navTitleStr;  //导航栏标题

@end
