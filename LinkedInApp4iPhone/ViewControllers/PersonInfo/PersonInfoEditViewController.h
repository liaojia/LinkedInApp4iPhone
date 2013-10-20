//
//  PersonInfoEditViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-19.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  个人履历节点修改||增加节点 根据pageType复用
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface PersonInfoEditViewController : UIViewController<UITableViewDataSource,
    UITableViewDelegate,
    UITextFieldDelegate,
    UIScrollViewDelegate,
    UIImagePickerControllerDelegate>
{
    NSArray *keyArray;
    UITextField *textfiled;
    UIImagePickerController *imagePicker;

}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (assign, nonatomic)UIViewController *fatherController;
@property (strong, nonatomic) ProfileModel *infoModel; //保存履历节点信息
@property (assign, nonatomic) int pageType; //0:节点修改 1：增加节点

- (IBAction)buttonClickerHandle:(id)sender;

@end
