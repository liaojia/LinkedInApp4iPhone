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
#import "ProfileViewController.h"
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
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(IBAction)registerAction:(id)sender
{
//    RegisterViewController *vc = [[RegisterViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}
@end
