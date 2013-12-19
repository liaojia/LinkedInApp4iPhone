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


@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *pswTxtField;
@property (weak, nonatomic) IBOutlet UITextField *pswConfirmTxtField;


@end
