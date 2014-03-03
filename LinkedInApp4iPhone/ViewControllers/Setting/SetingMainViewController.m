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
#import "AppDelegate.h"
#import "ProfileVC.h"
#import "OAuthWebView.h"
#import "AuthoritySetViewController.h"

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
 *	@brief	判断微博授权是否授权或授权过期
 *
 *	@return
 */
-(BOOL)isNeedToRefreshTheToken
{
    NSDate *expirationDate = [[NSUserDefaults standardUserDefaults]objectForKey:USER_STORE_EXPIRATION_DATE];
    if (expirationDate == nil)  return YES;
    
    BOOL boolValue1 = !(NSOrderedDescending == [expirationDate compare:[NSDate date]]);
    BOOL boolValue2 = (expirationDate != nil);
    
    return (boolValue1 && boolValue2);
}
/**
 *	@brief	跳转到新浪微博页面
 */
- (void)gotoSinaWeiBo
{
    ProfileVC *profile = [[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil];
    profile.userID = [NSString stringWithFormat:@"%@",@"2091014467"];
    [self.navigationController pushViewController:profile animated:YES];
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
        //[self logOut];
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
         [delegate.rootNavigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
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
        cell.imageView.image = [UIImage imageWithImage:[UIImage imageNamed:@"img_sina_weibo_64"] scaledToSize:CGSizeMake(25 , 25)] ;
        cell.textLabel.text = @" 官方微博";
    }
    else if (indexPath.section==1)
    {
        cell.imageView.image = [UIImage imageNamed:@"img_sys_modify_pwd"];
        cell.textLabel.text = @"   修改密码";
    }
    else if (indexPath.section==2)
    {
        cell.imageView.image = [UIImage imageWithImage:[UIImage imageNamed:@"icon_authority"] scaledToSize:CGSizeMake(20 , 20)] ;
        cell.textLabel.text = @"  权限设置";
    }
    
    else if (indexPath.section==3)
    {
        cell.imageView.image = [UIImage imageNamed:@"img_sys_update"];
        
        cell.textLabel.text = @"   检查更新";
    }
    else if (indexPath.section==4)
    {
        cell.imageView.image = [UIImage imageNamed:@"img_sys_about"];
        cell.textLabel.text = @"   关于";
    }
    else if (indexPath.section==5)
    {
        cell.imageView.image = [UIImage imageNamed:@"img_sys_exit"];
        cell.textLabel.text = @"   退出";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        
        //如果未授权或授权过期，则转入授权页面。
        NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
        if (authToken == nil || [self isNeedToRefreshTheToken])
        {
            
            OAuthWebView *webV = [[OAuthWebView alloc]initWithNibName:@"OAuthWebView" bundle:nil];
            webV.fatherController = self;
            [self.navigationController pushViewController:webV animated:NO];
            
        }
        else
        {
            [self gotoSinaWeiBo];
        }

    }
    else if (indexPath.section ==2) //权限设置
    {
        AuthoritySetViewController *authoritySetContoller = [[AuthoritySetViewController alloc]initWithNibName:@"AuthoritySetViewController" bundle:nil];
        [self.navigationController pushViewController:authoritySetContoller animated:YES];
    }
    else if (indexPath.section ==1) //密码修改
    {
        PassWordChangeViewController *pswChangeController = [[PassWordChangeViewController alloc]init];
        [self.navigationController pushViewController:pswChangeController animated:YES];
    }
    else if(indexPath.section == 3) //版本跟新
    {
        [self checkVerson];
    }
    else if(indexPath.section == 4) //关于
    {
        AboutViewController *aboutController = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutController animated:YES];
    }
    else if(indexPath.section == 5) //退出
    {
        [StaticTools showAlertWithTag:0
                                title:Nil
                              message:@"您确定要退出吗？"
                            AlertType:CAlertTypeCacel
                            SuperView:self];
    }
}
@end
