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
#import "CommitBasicInfoViewController.h"
#import "PersonInfoViewController.h"
#import "StudentInfoViewController.h"
#import "SchollInfoViewController.h"
#import "SetingMainViewController.h"

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
    [self.navigationController setNavigationBarHidden:YES];
    
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
    [_tf_pwd setInputTypePwd];
    [self.view addSubview:_tf_pwd];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--功能函数
/**
 *  跳转到首页
 */
- (void)gotoHome
{
    UITabBarController *tabbar  = [[UITabBarController alloc]init];
    if (IOS7_OR_LATER)
    {
        tabbar.tabBar.barStyle  = UIBarStyleBlackOpaque;
    }
    
    StudentInfoViewController *studentInfoController = [[StudentInfoViewController alloc]initWithNibName:@"StudentInfoViewController" bundle:nil];
    UINavigationController *studentNav = [[UINavigationController alloc]initWithRootViewController:studentInfoController];
    studentInfoController.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:nil tag:0];
    [studentInfoController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"img_group_friend_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"img_group_friend_normal"]];
    studentInfoController.tabBarItem.imageInsets = UIEdgeInsetsMake(20, 20, 13, 20);
    studentInfoController.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    studentInfoController.navigationController.delegate = studentInfoController.navigationController;
    
    SchollInfoViewController *schollInfoController = [[SchollInfoViewController alloc]initWithNibName:@"SchollInfoViewController" bundle:nil];
    UINavigationController *schoolNav = [[UINavigationController alloc]initWithRootViewController:schollInfoController];
    schollInfoController.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:nil tag:0];
    [schollInfoController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"img_group_school_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"img_group_school_normal"]];
     schollInfoController.tabBarItem.imageInsets = UIEdgeInsetsMake(20, 20, 13, 20);
    schollInfoController.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    schollInfoController.navigationController.delegate = schollInfoController.navigationController;
    
    PersonInfoViewController *personalCenterController = [[PersonInfoViewController alloc]initWithNibName:@"PersonInfoViewController" bundle:nil];
    UINavigationController *personNav = [[UINavigationController alloc]initWithRootViewController:personalCenterController];
    personalCenterController.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:nil tag:0];
    [personalCenterController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"img_group_profile_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"img_group_profile_normal"]];
     personalCenterController.tabBarItem.imageInsets = UIEdgeInsetsMake(20, 20, 13, 20);
    personalCenterController.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    personalCenterController.navigationController.delegate = personalCenterController.navigationController;
    

    
    SetingMainViewController *setingController = [[SetingMainViewController alloc]initWithNibName:@"SetingMainViewController" bundle:nil];
    UINavigationController *setingNav = [[UINavigationController alloc]initWithRootViewController:setingController];
    setingController.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:nil tag:0];
    [setingController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"img_group_setting_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"img_group_setting_normal"]];
     setingController.tabBarItem.imageInsets = UIEdgeInsetsMake(20, 20, 13, 20);
    setingController.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    setingController.navigationController.delegate = setingController.navigationController;
    
    
    
    tabbar.viewControllers = @[studentNav,schoolNav,personNav,setingNav];
    
    [self.navigationController pushViewController:tabbar animated:YES];
}
#pragma mark-
#pragma mark--按钮点击事件
-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)confirmAction:(id)sender{
        
    NSDictionary *requestDic = [[NSDictionary alloc] initWithObjectsAndKeys:_tf_username.getText, @"name", _tf_pwd.getText, @"password", nil];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:requestDic
         requesId:@"LOGIN"
           prompt:@"hell"
        replaceId:nil
          success:^(id obj) {
              
              [AppDataCenter sharedAppDataCenter].sid = [obj objectForKey:@"sid"];
              if ([[obj objectForKey:@"rc"]intValue] == 1) {
                  if (false) {
                      //-1尚未填写基本信息
                      CommitBasicInfoViewController *vc = [[CommitBasicInfoViewController alloc] initWithNibName:@"CommitBasicInfoViewController" bundle:[NSBundle mainBundle]];
                      [self.navigationController pushViewController:vc animated:YES];
                  }else{
                      if ([[obj objectForKey:@"status"]intValue] == 1) {
                          
                          [self gotoHome];
                          
//                          HomeViewController *homeControlelr = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
//                          self.navigationController.navigationBarHidden = NO;
//                          [self.navigationController pushViewController:homeControlelr animated:YES];
                          
                          
                      }else if([[obj objectForKey:@"status"]intValue] == -1){
                          //-1尚未填写基本信息
                          CommitBasicInfoViewController *vc = [[CommitBasicInfoViewController alloc] initWithNibName:@"CommitBasicInfoViewController" bundle:[NSBundle mainBundle]];
                          [self.navigationController pushViewController:vc animated:YES];
                          
                      }else if([[obj objectForKey:@"status"]intValue] == -2){
                          // -2等待审核
                          [self.navigationController popViewControllerAnimated:YES];
                          
                      }
                  }
                  
                
              }
              else if([[obj objectForKey:@"rc"]intValue] == -1){
                  // 0失败，未知原因
                  [SVProgressHUD showErrorWithStatus:@"失败，未知原因!"];
              }
              else if([[obj objectForKey:@"rc"]intValue] == -1){
                  // -1密码错误
                  [SVProgressHUD showErrorWithStatus:@"密码错误!"];
              }else if([[obj objectForKey:@"rc"]intValue] == -2 ){
                  // -2登录名不存在
                  [SVProgressHUD showErrorWithStatus:@"登录名不存在!"];
              }
              
              
          }
          failure:^(NSString *errMsg) {
              
          }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在登录..." completeBlock:^(NSArray *operations) {
       
        
    }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tf_username.tf_input resignFirstResponder];
    [_tf_pwd.tf_input resignFirstResponder];
}

@end
