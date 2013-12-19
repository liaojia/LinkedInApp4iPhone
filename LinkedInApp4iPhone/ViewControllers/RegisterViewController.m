//
//  RegisterViewController.m
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-9.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "RegisterViewController.h"
#import "ClearTextField.h"
#import "BasicInfoCommitViewController.h"
#define INTERVAL_1 80

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [super textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [super textFieldDidEndEditing:textField];
    
   
}
#pragma mark-
#pragma mark-按钮点击


-(IBAction)confirmAction:(id)sender
{
    NSString *errStr = nil;
    if ([StaticTools isEmptyString:self.nameTxtField.text])
    {
        errStr = @"请输入用户名！";
    }
    else if([StaticTools isEmptyString:self.pswTxtField.text])
    {
        errStr = @"请输入密码";
    }
    else if([StaticTools isEmptyString:self.pswConfirmTxtField.text])
    {
        errStr = @"请确认密码";
    }
    else if(![StaticTools isValidateEmail:self.nameTxtField.text])
    {
        errStr = @"请输入一个正确的邮箱作为用户名";
    }
    else if(![self.pswTxtField.text isEqualToString:self.pswConfirmTxtField.text])
    {
        errStr = @"两次输入的密码不一致！";
    }
    if(errStr !=nil)
    {
        [SVProgressHUD showErrorWithStatus:errStr];
        return;
    }

    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"name":self.pswTxtField.text,@"password":self.pswConfirmTxtField.text} requesId:@"REGISTER" messId:nil success:^(id obj)
             {
                 //返回1时表示注册成功 且后台默认为登陆状态  返回sessionid
                 if ([[obj objectForKey:@"rc"]intValue] == 1)
                 {
                     [AppDataCenter sharedAppDataCenter].sid = [obj objectForKey:@"sid"];
                     //跳转到基本信息填写页面
                     BasicInfoCommitViewController *basicInfoCommitController = [[BasicInfoCommitViewController alloc] initWithNibName:@"BasicInfoCommitViewController" bundle:[NSBundle mainBundle]];
                     [self.navigationController pushViewController:basicInfoCommitController animated:YES];
                     
                 }
                 else if([[obj objectForKey:@"rc"]intValue] == -2)
                 {
                     [SVProgressHUD showErrorWithStatus:@"该账号已被注册过！"];
                 }
                 else
                 {
                     [SVProgressHUD showErrorWithStatus:@"注册失败，请稍后再试！"];
                 }
                 
                 
             } failure:nil];

    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
                                   completeBlock:nil];

    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
