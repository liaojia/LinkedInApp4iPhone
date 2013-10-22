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

@synthesize tf_username = _tf_username;
@synthesize tf_pwd = _tf_pwd;
@synthesize tf_confirm_pwd = _tf_confirm_pwd;

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
    _tf_username.tf_input.placeholder = @"请输入邮箱作为用户名";
    [self.view addSubview:_tf_username];
    
    _tf_pwd = [[ClearTextField alloc] initWithFrame:CGRectMake(10, 120+INTERVAL_1, 300, 40)];
    _tf_pwd.tf_input.placeholder = @"请输入密码";
    _tf_pwd.tf_input.secureTextEntry = YES;
    [self.view addSubview:_tf_pwd];
    
    _tf_confirm_pwd = [[ClearTextField alloc] initWithFrame:CGRectMake(10, 120+2*INTERVAL_1, 300, 40)];
    _tf_confirm_pwd.tf_input.delegate = self;
    _tf_confirm_pwd.tf_input.placeholder = @"请确认密码";
    _tf_confirm_pwd.tf_input.SecureTextEntry = YES;
    [self.view addSubview:_tf_confirm_pwd];
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(10, 120+2*INTERVAL_1, 300, 40)];
    [field setBackgroundColor:[UIColor redColor]];
    field.delegate = self;
//    [self.view addSubview:field];
    
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
-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)confirmAction:(id)sender
{
    NSString *errStr = nil;
    if ([StaticTools isEmptyString:self.tf_username.tf_input.text])
    {
        errStr = @"请输入用户名！";
    }
    else if([StaticTools isEmptyString:self.tf_pwd.tf_input.text])
    {
        errStr = @"请输入密码";
    }
    else if([StaticTools isEmptyString:self.tf_confirm_pwd.tf_input.text])
    {
        errStr = @"请确认密码";
    }
    else if(![StaticTools isValidateEmail:self.tf_username.tf_input.text])
    {
        errStr = @"请输入一个正确的邮箱作为用户名";
    }
    else if(![self.tf_confirm_pwd.tf_input.text isEqualToString:self.tf_pwd.tf_input.text])
    {
        errStr = @"两次输入的密码不一致！";
    }
    if(errStr !=nil)
    {
        [SVProgressHUD showErrorWithStatus:errStr];
        return;
    }

    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"name":self.tf_username.tf_input.text,@"password":self.tf_confirm_pwd.tf_input.text} requesId:@"REGISTER" messId:nil success:^(id obj)
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
    [_tf_username.tf_input resignFirstResponder];
    [_tf_pwd.tf_input resignFirstResponder];
    [_tf_confirm_pwd.tf_input resignFirstResponder];
}

@end
