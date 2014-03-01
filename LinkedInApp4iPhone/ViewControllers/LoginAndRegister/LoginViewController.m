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
#import "RegisterViewController.h"
#import "MyCircleViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController



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
    
    self.nameTxtField.text = @"20131014001@qq.com";
    self.psaTxtField.text = @"123";
    
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
    studentInfoController.tabBarItem.imageInsets = UIEdgeInsetsMake(25, 22, 13, 22);
    studentInfoController.navigationController.delegate = studentInfoController.navigationController;
        
    SchollInfoViewController *schollInfoController = [[SchollInfoViewController alloc]initWithNibName:@"SchollInfoViewController" bundle:nil];
    UINavigationController *schoolNav = [[UINavigationController alloc]initWithRootViewController:schollInfoController];
    schollInfoController.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:nil tag:0];
    [schollInfoController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"img_group_school_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"img_group_school_normal"]];
     schollInfoController.tabBarItem.imageInsets = UIEdgeInsetsMake(25, 22, 13, 22);
    schollInfoController.navigationController.delegate = schollInfoController.navigationController;
    
    PersonInfoViewController *personalCenterController = [[PersonInfoViewController alloc]initWithNibName:@"PersonInfoViewController" bundle:nil];
    UINavigationController *personNav = [[UINavigationController alloc]initWithRootViewController:personalCenterController];
    personalCenterController.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:nil tag:0];
    [personalCenterController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"img_group_profile_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"img_group_profile_normal"]];
     personalCenterController.tabBarItem.imageInsets = UIEdgeInsetsMake(25, 22, 13, 22);
    personalCenterController.navigationController.delegate = personalCenterController.navigationController;
    

    
    SetingMainViewController *setingController = [[SetingMainViewController alloc]initWithNibName:@"SetingMainViewController" bundle:nil];
    UINavigationController *setingNav = [[UINavigationController alloc]initWithRootViewController:setingController];
    setingController.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:nil tag:0];
    [setingController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"img_group_setting_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"img_group_setting_normal"]];
     setingController.tabBarItem.imageInsets = UIEdgeInsetsMake(25, 22, 13, 22);
    setingController.navigationController.delegate = setingController.navigationController;
    
    
    MyCircleViewController *myCircelController = [[MyCircleViewController alloc]initWithNibName:@"MyCircleViewController" bundle:nil];
    UINavigationController *circleNav = [[UINavigationController alloc]initWithRootViewController:myCircelController];
    myCircelController.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:nil tag:0];
    [myCircelController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"img_group_circle_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"img_group_circle_nomal"]];
    myCircelController.tabBarItem.imageInsets = UIEdgeInsetsMake(25, 22, 13, 22);
    myCircelController.navigationController.delegate = myCircelController.navigationController;
    
    if (APPTYPE == kAppTypeHaveCircle)
    {
        tabbar.viewControllers = @[studentNav,schoolNav,personNav,circleNav,setingNav];
    }
    else
    {
        tabbar.viewControllers = @[studentNav,schoolNav,personNav,setingNav];
    }
    
    
    
    [self.navigationController pushViewController:tabbar animated:YES];
    
  
}
#pragma mark-
#pragma mark--按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button.tag==100)
    {
        RegisterViewController *regsiterController = [[RegisterViewController alloc]init];
        [self.navigationController pushViewController:regsiterController animated:YES];
    }
    else if(button.tag==101)
    {
        [self confirmAction];
    }
}

-(void)confirmAction
{
        
    NSDictionary *requestDic = [[NSDictionary alloc] initWithObjectsAndKeys:self.nameTxtField.text, @"name", self.psaTxtField.text, @"password", nil];
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

    [self.view endEditing:YES];
}

@end
