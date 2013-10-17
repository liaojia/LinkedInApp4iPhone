//
//  ProfileViewController.m
//  LinkedInApp4iPhone
//
//  Created by liao jia on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileModel.h"
#define TOPBAR_H 50
#define H_CELL 100
#define W_CELL_LABEL 150
#define H_CELL_LABEL 30
@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize searchTF = _searchTF;
@synthesize mTableView = _mTableView;
@synthesize sectionCount = _sectionCount;
@synthesize array_timeline = _array_timeline;
@synthesize array_myattention = _array_myattention;
@synthesize array_fans = _array_fans;
@synthesize dic_array = _dic_array;

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

    [self initData];
    UIImageView *topBarIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, TOPBAR_H)];
    [topBarIV setImage:[UIImage imageNamed:@"img_school_notice_normal"]];
    [topBarIV setUserInteractionEnabled:YES];
    [self.view addSubview:topBarIV];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(5, (TOPBAR_H-31)/2.0, 31, 31)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"img_list_normal"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"img_list_pressed"] forState:UIControlStateSelected];
    [backButton setBackgroundImage:[UIImage imageNamed:@"img_list_pressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBarIV addSubview:backButton];
    
    UIImageView *searchBgIV = [[UIImageView alloc] initWithFrame:CGRectMake(40, (TOPBAR_H-H_CELL_LABEL)/2.0, 220, H_CELL_LABEL)];
    [searchBgIV setUserInteractionEnabled:YES];
    [searchBgIV setImage:[UIImage imageNamed:@"img_topbar_searchbox"]];
    [self.view addSubview:searchBgIV];
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(3, 5, 200, H_CELL_LABEL)];
    [searchBgIV addSubview:_searchTF];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setFrame:CGRectMake(280, (TOPBAR_H-H_CELL_LABEL)/2.0, 32, H_CELL_LABEL)];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"img_topbar_search_normal"] forState:UIControlStateNormal];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"img_topbar_search_pressed"] forState:UIControlStateSelected];
    [searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [topBarIV addSubview:searchButton];
    
    
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarIV.frame.size.height+5, 320, 400) style:UITableViewStyleGrouped];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    [self.view addSubview:_mTableView];
    
}

-(void)initData{

    _sectionCount = 4;
    _dic_array = [[NSMutableDictionary alloc] init];
    
    ProfileModel *model0 = [[ProfileModel alloc] init];
    [model0 setMName:@"老张"];
    [model0 setMCity:@"北京"];
    [model0 setMSchool:@"清华大学"];
    [model0 setMGender:@"男"];
    
    ProfileModel *model1 = [[ProfileModel alloc] init];
    [model1 setMName:@"老王"];
    [model1 setMCity:@"上海"];
    [model1 setMSchool:@"联合大学"];
    [model1 setMGender:@"女"];
    
    _array_timeline = [[NSMutableArray alloc] init];
    [_array_timeline addObject:model0];
    [_array_timeline addObject:model1];
    [_dic_array setObject:_array_timeline forKey:@"array_timeline"];
    
    _array_myattention = [[NSMutableArray alloc] init];
    [_array_myattention addObject:model0];
    [_dic_array setObject:_array_timeline forKey:@"array_myattention"];
    
    _array_fans = [[NSMutableArray alloc] init];
    [_array_fans addObject:model0];
    [_dic_array setObject:_array_fans forKey:@"array_fans"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)searchAction:(id)sender
{
    
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = 1;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = [_array_timeline count];
            break;
        case 2:
            count = [_array_myattention count];
            break;
        case 3:
            count = [_array_fans count];
            break;
            
        default:
            break;
    }
    return count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *header = @"";
    switch (section) {
        case 0:
            break;
        case 1:
            header = @"个人履历";
            break;
        case 2:
            header = @"我关注的人";
            break;
        case 3:
            header = @"关注我的人";
            break;
        default:
            break;
    }
    return header;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //避免重叠
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    UIImageView *userheadIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, (H_CELL-80)/2.0, 50, 80)];
    [userheadIV setImage:[UIImage imageNamed:@"img_weibo_userinfo_male_2"]];
    [cell.contentView addSubview:userheadIV];
    
    UILabel *l_name = [[UILabel alloc] initWithFrame:CGRectMake(10, (H_CELL-80)/2.0, W_CELL_LABEL, H_CELL_LABEL)];
    [l_name setText:@"name"];
    [cell.contentView addSubview:l_name];
    
    UILabel *l_gender = [[UILabel alloc] initWithFrame:CGRectMake(10, (H_CELL-80)/2.0+H_CELL_LABEL, W_CELL_LABEL, H_CELL_LABEL)];
    [l_gender setText:@"gender"];
    [cell.contentView addSubview:l_gender];
    
    UILabel *l_sclool = [[UILabel alloc] initWithFrame:CGRectMake(10, (H_CELL-80)/2.0+H_CELL_LABEL*2, W_CELL_LABEL, H_CELL_LABEL)];
    [l_sclool setText:@"school"];
    [cell.contentView addSubview:l_sclool];
    
    UILabel *l_city = [[UILabel alloc] initWithFrame:CGRectMake(10, (H_CELL-80)/2.0+H_CELL_LABEL*3, W_CELL_LABEL, H_CELL_LABEL)];
    [l_city setText:@"city"];
    [cell.contentView addSubview:l_city];
    switch (indexPath.section) {
        case 0:
        {
        
        
        }
            break;
        case 1:
        {
            
            
        }
            break;
        case 2:
        {
            
            
        }
            break;
        case 3:
        {
            
            
        }
            break;
            
        default:
            break;
    }
    return cell;
}
@end
