//
//  LoginViewController.h
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-8.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class ClearTextField;

@interface LoginViewController : BaseViewController


@property(nonatomic, strong)ClearTextField *tf_username;
@property(nonatomic, strong)ClearTextField *tf_pwd;

@end
