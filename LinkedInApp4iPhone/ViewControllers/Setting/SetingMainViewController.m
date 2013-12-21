//
//  SetingMainViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "SetingMainViewController.h"
#import "PassWordChangeViewController.h"
#import "AboutViewController.h"

@interface SetingMainViewController ()

@end

@implementation SetingMainViewController

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
    
    self.navigationItem.title = @"设置";
    
    self.listTableView.backgroundView = nil;
    self.listTableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--发送http请求
/**
 *  退出登录
 */
- (void)logOut
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"sid":[AppDataCenter sharedAppDataCenter].sid} requesId:@"USERLOGOUT" messId:nil success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 [self.navigationController popToRootViewControllerAnimated:YES];
                                                 
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -1)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"退出失败，请稍后再试!"];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"退出失败，请稍后再试!"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"正在退出..."
                                   completeBlock:nil];
}

/**
 *  检查版本跟新
 */
- (void)checkVerson
{
    [StaticTools showAlertWithTag:0
                            title:Nil
                          message:@"已经是最新版本，不需要更新！"
                        AlertType:CAlertTypeDefault
                        SuperView:Nil];

}
#pragma mark-
#pragma mark--UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=alertView.cancelButtonIndex)
    {
        [self logOut];
    }
}
#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section==0)
    {
        cell.imageView.image = [UIImage imageNamed:@"img_sys_modify_pwd"];
        cell.textLabel.text = @"   修改密码";
    }
    else if (indexPath.section==1)
    {
        cell.imageView.image = [UIImage imageNamed:@"img_sys_update"];
        
        cell.textLabel.text = @"   检查更新";
    }
    else if (indexPath.section==2)
    {
        cell.imageView.image = [UIImage imageNamed:@"img_sys_about"];
        cell.textLabel.text = @"   关于";
    }
    else if (indexPath.section==3)
    {
        cell.imageView.image = [UIImage imageNamed:@"img_sys_exit"];
        cell.textLabel.text = @"   退出";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) //密码修改
    {
        PassWordChangeViewController *pswChangeController = [[PassWordChangeViewController alloc]init];
        [self.navigationController pushViewController:pswChangeController animated:YES];
    }
    else if(indexPath.section == 1) //版本跟新
    {
        [self checkVerson];
    }
    else if(indexPath.section == 2) //关于
    {
        AboutViewController *aboutController = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutController animated:YES];
    }
    else if(indexPath.section == 3) //退出
    {
        [StaticTools showAlertWithTag:0
                                title:Nil
                              message:@"您确定要退出吗？"
                            AlertType:CAlertTypeCacel
                            SuperView:self];
    }
}
@end
