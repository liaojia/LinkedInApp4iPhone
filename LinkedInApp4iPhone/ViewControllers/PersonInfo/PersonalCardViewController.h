//
//  PersonalCardViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-20.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  个人名片页面
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface PersonalCardViewController : UIViewController<UITableViewDataSource,
    UITableViewDelegate,
    UIImagePickerControllerDelegate,
    UITextViewDelegate,
    UIScrollViewDelegate>
{
     UIImagePickerController *imagePicker;
     NSArray *keyArray;
    UITextView *selectTextView;
    UIImage *selectImg;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (strong, nonatomic) ProfileModel *infoModel;
@property (assign, nonatomic) UIViewController *fatherContrller;
- (IBAction)buttonClickHandle:(id)sender;
@end
