//
//  AddRegisterInfoViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-27.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：完善注册信息页面
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
@class SingleSelectCell;\
@interface AddRegisterInfoViewController : UIViewController<UIScrollViewDelegate,
    UIActionSheetDelegate,
    UITextFieldDelegate,
    UIImagePickerControllerDelegate>
{
    int cerType; //身份类型 0：教工校友  1：学生校友
    UIImage *selectImg;
    UIImagePickerController *imagePicker;
    int selectYear;
    
    SingleSelectCell *sigleCell;

}
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) NSMutableArray *departments; //保存院系列表
@property (strong, nonatomic) NSMutableArray *companys;    //保存组织机构列表
@property (strong, nonatomic) NSMutableArray *majors;
@property (strong, nonatomic) NSDictionary *selectDepartment; //选择的院系信息
@property (strong, nonatomic) NSDictionary *selectMajor; //选择的专业信息
@property (strong, nonatomic) NSDictionary *selectFistCompany; //选择的一级单位信息
@property (strong, nonatomic) NSDictionary *selectSecCompaye; //选择的二级单位信息
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phonenum;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *qqNum;
@property (strong, nonatomic) NSString *classNum;
@property (strong, nonatomic) NSString *workerNum;
@end
