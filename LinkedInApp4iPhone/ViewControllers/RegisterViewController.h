//
//  RegisterViewController.h
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-9.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class ClearTextField;

@interface RegisterViewController : BaseViewController

@property(nonatomic, strong)ClearTextField *tf_username;
@property(nonatomic, strong)ClearTextField *tf_pwd;
@property(nonatomic, strong)ClearTextField *tf_confirm_pwd;

@end
