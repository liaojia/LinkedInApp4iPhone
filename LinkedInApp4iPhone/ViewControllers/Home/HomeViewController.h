//
//  HomeViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-15.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 // 
 //
 // 文件功能描述：  软件首页
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/

#import <UIKit/UIKit.h> 
#import "PersonInfoViewController.h"

@interface HomeViewController : UIViewController<UITableViewDataSource,
    UITableViewDelegate>
{
    NSArray *testArray; //测试数据
    
    PersonInfoViewController *personInfoController;
}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

- (IBAction)buttonClickedHandle:(id)sender;
@end
