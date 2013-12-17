//
//  SchollCardApplyViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-17.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "SchollCardApplyViewController.h"

@interface SchollCardApplyViewController ()

@end

@implementation SchollCardApplyViewController

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.pageType==0? @"申请校友龙卡":@"申请捐赠";
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
    if ([StaticTools isEmptyString:self.nameTxtField.text])
    {
        err = @"请输入您的姓名!";
    }
    else if([StaticTools isEmptyString:self.emailTxtField.text])
    {
        err = @"请输入邮箱信息！";
    }
    else if([StaticTools isEmptyString:self.phoneTextField.text])
    {
        err = @"请输入您的手机号码！";
    }
    else if(![StaticTools isValidateEmail:self.emailTxtField.text])
    {
         err = @"输入的邮箱地址不合法！";
    }
    else if(![StaticTools isMobileNumber:self.phoneTextField.text])
    {
        err = @"输入的手机号码不合法！";
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
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"name":self.nameTxtField.text,@"email":self.emailTxtField.text,@"mobile":self.phoneTextField.text} requesId:self.pageType==0? @"APPLEFOCCHOLLCARD":@"APPLEFORFEEDBACK" messId:nil success:^(id obj)
                                     {
                                         if ([[obj objectForKey:@"rc"]intValue] == 1)
                                         {
                                            [SVProgressHUD showErrorWithStatus:@"申请成功"];
                                             [self.navigationController popViewControllerAnimated:YES];
                                             
                                         }
                                         else if([[obj objectForKey:@"rc"]intValue] == -2)
                                         {
                                            [SVProgressHUD showErrorWithStatus:@"您已提交过申请"];
                                         }
                                         else
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"申请失败，请稍后再试！"];
                                         }
                                         
                                         
                                     } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
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
