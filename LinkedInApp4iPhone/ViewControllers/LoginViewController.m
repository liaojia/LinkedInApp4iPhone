//
//  LoginViewController.m
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-8.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "LoginViewController.h"
#import "ClearTextField.h"
#import "HomeViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize tf_username = _tf_username;
@synthesize tf_pwd = _tf_pwd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_login_backdrop"]]];
    UIButton *btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_back setFrame:CGRectMake(15, 15, 30, 30)];
    [self setButtonBgWithNomal:@"img_login_back_normal" selectedImageStr:@"img_login_back_pressed" button:btn_back];
    [btn_back addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_back];
    
    UIButton *btn_confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_confirm setFrame:CGRectMake(275, 15, 30, 30)];
    [self setButtonBgWithNomal:@"img_login_completed_normal" selectedImageStr:@"img_login_completed_pressed" button:btn_confirm];
    [btn_confirm addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_confirm];
    
    _tf_username = [[ClearTextField alloc] initWithFrame:CGRectMake(10, 120, 300, 40)];
    [_tf_username.tf_input setText:@"20131014001@qq.com"];
    [self.view addSubview:_tf_username];
    
    _tf_pwd = [[ClearTextField alloc] initWithFrame:CGRectMake(10, 200, 300, 40)];
    [_tf_pwd.tf_input setText:@"123"];
    [self.view addSubview:_tf_pwd];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)confirmAction:(id)sender{
    
    HomeViewController *homeControlelr = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:homeControlelr animated:YES];
    
    NSDictionary *requestDic = [[NSDictionary alloc] initWithObjectsAndKeys:_tf_username.getText, @"name", _tf_pwd.getText, @"password", nil];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:requestDic
                                                                                 requesId:@"LOGIN"
                                                                                   prompt:@"hell"
                                                                                  success:^(id obj) {
                                                                                      NSLog(@"login: %@", obj);
                                                                                      
                                                                                  }
                                                                                  failure:^(NSString *errMsg) {
                                                                                      
                                                                                  }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在检查更新" completeBlock:^(NSArray *operations) {
        //        NSString *version = [respDic objectForKey:@"VERSION"];
        //        if ([version isEqualToString:kVERSION]) {
        //            // 无需更新
        //            //[SVProgressHUD showSuccessWithStatus:@"已是最新版本"];
        //            [[LKTipCenter defaultCenter] postDownTipWithMessage:@"您的程序已是最新版本" time:2];
        //
        //            if ([UserDefaults boolForKey:kAUTOLOGIN]) {
        //                [self loginAction:nil];
        //            }
        //
        //        } else {
        // 启动浏览器去更新程序
        
        // 注：这种机制也没有完全要求用户一定要更新程序，完全可以从浏览器切换回项目再登录。
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[respDic objectForKey:@"URL"]]];
        
        //        }
        

        
    }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tf_username.tf_input resignFirstResponder];
    [_tf_pwd.tf_input resignFirstResponder];
}

@end
