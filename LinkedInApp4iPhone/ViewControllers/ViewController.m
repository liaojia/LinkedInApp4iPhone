//
//  ViewController.m
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-8.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize btn_login = _btn_login;
@synthesize btn_register = _btn_register;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_login_backdrop"]]];
    [self.navigationController setNavigationBarHidden:YES];
    _btn_login = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setButtonBgWithNomal:@"img_login_btn_normal" selectedImageStr:@"img_login_btn_pressed" button:_btn_login];
    [_btn_login setFrame:CGRectMake(50, 320, 50, 35)];
    [_btn_login.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_btn_login setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:_btn_login];
    [_btn_login addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn_register = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setButtonBgWithNomal:@"img_login_btn_normal" selectedImageStr:@"img_login_btn_pressed" button:_btn_register];
    [_btn_register setFrame:CGRectMake(220, 320, 50, 35)];
    [_btn_register.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_btn_register setTitle:@"注册" forState:UIControlStateNormal];
    [_btn_register addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_register];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)loginAction:(id)sender{
//   
//    LoginViewController *vc = [[LoginViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:nil
                                                                                   prompt:nil
                                                                                  success:^(id obj) {
                                                                                      
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

-(IBAction)registerAction:(id)sender
{
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
