//
//  RegisterViewController.m
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-9.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "RegisterViewController.h"
#import "ClearTextField.h"

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
    [self.view addSubview:_tf_username];
    
    _tf_pwd = [[ClearTextField alloc] initWithFrame:CGRectMake(10, 120+INTERVAL_1, 300, 40)];
    [self.view addSubview:_tf_pwd];
    
    _tf_confirm_pwd = [[ClearTextField alloc] initWithFrame:CGRectMake(10, 120+2*INTERVAL_1, 300, 40)];
    _tf_confirm_pwd.tf_input.delegate = self;
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

-(IBAction)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)confirmAction:(id)sender{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tf_username.tf_input resignFirstResponder];
    [_tf_pwd.tf_input resignFirstResponder];
    [_tf_confirm_pwd.tf_input resignFirstResponder];
}

@end
