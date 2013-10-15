//
//  HomeViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-15.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if(section == 2)
    {
        return 3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0||indexPath.row == 0)
    {
        return 80;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdenti";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) //学校简介
    {
        
    }
    else
    {
        
        if (indexPath.row == 0) //section组别标题
        {
            //标题文字
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = @"通知公告";
            
            //UIButton *detailBtn = [UIButton buttonWithType:UIButton
        }
    }
    
    
    cell.textLabel.text = @"test";
    
    return cell;
    
}
@end
