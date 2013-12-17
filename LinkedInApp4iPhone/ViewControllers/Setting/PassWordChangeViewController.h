//
//  PassWordChangeViewController.h
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-17.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) XXXXXXXXXXXXX
 //
 //
 // 文件功能描述：  密码修改页面
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface PassWordChangeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *oldPswTxtField;
@property (weak, nonatomic) IBOutlet UITextField *nowPswTxtField;
@property (weak, nonatomic) IBOutlet UITextField *nowPswConfirmTxtField;

-(IBAction)buttonClickHandle:(id)sender;
@end
