//
//  AuthoritySetViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 14-3-3.
//  Copyright (c) 2014年 liao jia. All rights reserved.
//

#import "AuthoritySetViewController.h"

@interface AuthoritySetViewController ()

@end

@implementation AuthoritySetViewController

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
    self.navigationItem.title = @"权限设置";
    
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.backgroundView = nil;
    self.qqAuth = @"0";
    self.emailAuth = @"0";
    self.phoneAuth = @"0";
    // Do any additional setup after loading the view from its nib.
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(280, 5, 70, 30);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightBtn.tag = 201;
    [rightBtn setTitle:@"保存修改" forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_find_stu_n"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_find_stu_s"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self getAutority];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark 按钮点击
- (void)buttonClickHandle:(id)sender
{
    [self changeAutority];
}
#pragma mark-
#pragma mark--发送http请求
/**
 *  获取权限信息
 */
- (void)getAutority
{
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:nil requesId:@"GETMYAUTHORITY" messId:nil success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 
                                                 self.qqAuth = obj[@"qq"];
                                                 self.phoneAuth = obj[@"mobile"];
                                                 self.emailAuth = obj[@"email"];
                                                 
                                                 [self.listTableView reloadData];
                                                 
                                                 
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"密码修改失败，请稍后再试！"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"正在获取权限信息..."
                                   completeBlock:nil];
}

/**
 *  修改我的权限信息
 */
- (void)changeAutority
{
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"qq":self.qqAuth,@"mobile":self.phoneAuth,@"email":self.emailAuth} requesId:@"CHANGEMYAUTHORITY" messId:nil success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 
                                                
                                                 [SVProgressHUD showSuccessWithStatus:@"权限修改成功！"];
                                                 
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"权限修改失败，请稍后再试！"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"正在修改权限信息..."
                                   completeBlock:nil];
}

- (void)valueChange:(id)sender
{
    UISwitch *segment  = (UISwitch*)sender;
    switch (segment.tag)
    {
        case 100:
        {
            self.qqAuth = [NSString stringWithFormat:@"%d",segment.isOn?1:0];
        }
            break;
        case 101:
        {
            self.phoneAuth = [NSString stringWithFormat:@"%d",segment.isOn?1:0];
        }
            break;
        case 102:
        {
            self.emailAuth = [NSString stringWithFormat:@"%d",segment.isOn?1:0];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [cell.contentView addSubview:titleLabel];
    
    UISwitch *switchCon = [[UISwitch alloc]initWithFrame:CGRectMake(IOS7_OR_LATER?250:210,10, 70,30)];
    [cell.contentView addSubview:switchCon];
    
    switchCon.tag = 100+indexPath.section;
    [switchCon addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];

    if (indexPath.section==0)
    {
         titleLabel.text = @"公开QQ号码";
        [switchCon setOn:[self.qqAuth boolValue]];
       
    }
    else if(indexPath.section==1)
    {
         titleLabel.text = @"公开手机号";
        [switchCon setOn:[self.phoneAuth boolValue]];
    }
    else if(indexPath.section==2)
    {
         titleLabel.text = @"公开邮箱";
        [switchCon setOn:[self.emailAuth boolValue]];

    }
    

    return cell;
}

@end
