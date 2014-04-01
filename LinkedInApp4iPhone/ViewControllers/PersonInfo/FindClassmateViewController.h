//
//  FindClassmateViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-21.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  相页面
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface FindClassmateViewController : UIViewController<UISearchBarDelegate,
    UIScrollViewDelegate>
{
    int currentPage;
    BOOL clickSearch;
}
@property (weak, nonatomic)IBOutlet UITableView *listTableView;
@property (weak, nonatomic)IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *resultMtbArray;
@property (assign, nonatomic) UIViewController *fatherViewController;
@end
