//
//  RegisterViewController.h
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-9.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述： 注册页面
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface RegisterViewController : BaseViewController<UITextFieldDelegate>
{
    CGRect frame;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTxtField; //姓名
@property (weak, nonatomic) IBOutlet UITextField *pswTxtField;  //密码
@property (weak, nonatomic) IBOutlet UITextField *pswConfirmTxtField; //确认密码
@property (weak, nonatomic) IBOutlet UITextField *certificateNum; //身份证号
@property (weak, nonatomic) IBOutlet UITextField *studentNum; //学号
@property (weak, nonatomic) IBOutlet UIScrollView *mainScr;

- (IBAction)backClick:(id)sender;

@end
