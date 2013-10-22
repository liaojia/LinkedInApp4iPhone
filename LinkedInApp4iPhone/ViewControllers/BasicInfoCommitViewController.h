//
//  BasicInfoCommitViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-22.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  基本信息提交页面
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface BasicInfoCommitViewController : UIViewController<UITableViewDataSource,
    UITableViewDelegate,
    UITextViewDelegate>
{
    NSArray *keyArray;
    UITextView *selectTextView;
}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) ProfileModel *infoModel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end
