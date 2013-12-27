//
//  RegisterViewController.h
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-9.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface RegisterViewController : BaseViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *nameTxtField; //姓名
@property (weak, nonatomic) IBOutlet UITextField *pswTxtField;  //密码
@property (weak, nonatomic) IBOutlet UITextField *pswConfirmTxtField; //确认密码
@property (weak, nonatomic) IBOutlet UITextField *certificateNum; //身份证号
@property (weak, nonatomic) IBOutlet UITextField *studentNum; //学号


@end
