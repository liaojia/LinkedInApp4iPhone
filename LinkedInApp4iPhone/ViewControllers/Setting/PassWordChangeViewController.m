//
//  PassWordChangeViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-17.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "PassWordChangeViewController.h"

@interface PassWordChangeViewController ()

@end

@implementation PassWordChangeViewController

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
    
    self.navigationItem.title = @"密码修改";
    // Do any additional setup after loading the view from its nib.
    
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--功能函数
/**
 *  检查页面输入合法性
 *
 *  @return
 */
-(BOOL)checkInputValue
{
    NSString *err;
    if ([StaticTools isEmptyString:self.oldPswTxtField.text])
    {
        err = @"请输入原密码!";
    }
    else if([StaticTools isEmptyString:self.nowPswTxtField.text])
    {
        err = @"请输入新密码！";
    }
    else if([StaticTools isEmptyString:self.nowPswConfirmTxtField.text])
    {
        err = @"请确认新密码！";
    }

    
    if (err!=nil)
    {
        [SVProgressHUD showErrorWithStatus:err];
        return NO;
    }
    
    return YES;
}
#pragma mark-
#pragma mark--发送http请求
- (void)appForSchollCard
{
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"old":self.oldPswTxtField.text,@"new":self.nowPswTxtField.text} requesId:@"CHAGNEPASSWORD" messId:nil success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"密码修改成功！"];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                                 
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -1)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"原始密码错误!"];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"密码修改失败，请稍后再试！"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"正在提交..."
                                   completeBlock:nil];
    
}
#pragma mark-
#pragma mark--按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    if ([self checkInputValue])
    {
        [self appForSchollCard];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
