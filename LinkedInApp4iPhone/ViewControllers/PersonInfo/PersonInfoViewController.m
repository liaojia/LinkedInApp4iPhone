//
//  PersonInfoViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "AppDelegate.h"
#import "PersonInfoCell.h"
#import "CommendListViewController.h"
#import "PersonCell.h"
#import "PersonHeadView.h"
#import "ProfileModel.h"

@interface PersonInfoViewController ()

@end

@implementation PersonInfoViewController
@synthesize model = _model;
@synthesize timeLimeArray = _timeLimeArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        myNoticeCount = 13;
        NoticeMeCount = 8;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.backgroundView = nil;
    
    self.timeLimeArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self refreshData];
}
- (void)viewDidUnload
{
    [self setListTableView:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    
    UIButton *button  = (UIButton*)sender;
    if (button.tag>=200)
    {
        PersonInfoViewController *perosnInforController = [[PersonInfoViewController alloc]initWithNibName:@"PersonInfoViewController" bundle:[NSBundle mainBundle]];
        perosnInforController.pageType = 1;
        AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appdelegate.rootNavigationController pushViewController:perosnInforController animated:YES];
        
    }
    switch (button.tag)
    {
        case 102: //我的关注列表类型改变
        {
            myNoticeListType = myNoticeListType == 0?1:0;
            [button setImage:[UIImage imageNamed:myNoticeListType == 0?@"img_card_list_two":@"img_card_list_one"] forState:UIControlStateNormal];
            [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
            
        }
            break;
        case 103: //关注我的列表类型改变
        {
            NoticeMeListType = NoticeMeListType == 0?1:0;
            [button setImage:[UIImage imageNamed:NoticeMeListType == 0?@"img_card_list_two":@"img_card_list_one"] forState:UIControlStateNormal];
            [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
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
    return self.pageType == 0?4:2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }else if(section == 1){
        return [self.timeLimeArray count];
    }
    else if(section == 2||section == 3)
    {
        int type = section ==2?myNoticeListType:NoticeMeListType;
        int count = section ==2?myNoticeCount:NoticeMeCount;
        
        if (type == 0)
        {
            return count+1;
        }
        else
        {
            if (count%3==0)
            {
                return count/3+1;
            }
            else
            {
                return count/3+2;
            }
        }
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 130;
    }
    else if(indexPath.section == 1)
    {
        
        return indexPath.row == 0?44:110;
    }
    if (indexPath.section == 2||indexPath.section==3)
    {
        if (indexPath.row == 0)
        {
           return 44;
        }
        
        if ((myNoticeListType == 1&&indexPath.section == 2)
            ||(NoticeMeListType == 1&&indexPath.section == 3))
        {
            return 130;
        }
        return 100;
    }
    return 130;
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
    // cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    if( indexPath.row == 0&&indexPath.section!=0) //title
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        NSString *titleStr;
        if (indexPath.section == 1)
        {
            titleStr = @"个人履历";
        }
        else if(indexPath.section == 2)
        {
            titleStr = @"个人关注";
        }
        else if(indexPath.section == 3)
        {
            titleStr = @"关注我的人";
        }
        titleLabel.text =  titleStr;
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.section==2||indexPath.section == 3)
        {
            UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            typeBtn.frame = CGRectMake(260, 5, 35, 35);
            typeBtn.tag = 100+indexPath.section;
            [typeBtn setImage:[UIImage imageNamed:@"img_card_list_two"] forState:UIControlStateNormal];
            [typeBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:typeBtn];
          

        }
    }
    else if (indexPath.section == 0) //个人资料
    {
        NSString *name = nil;
        NSString *dept = nil;
        NSString *major = nil;
        if (_model) {
            name = _model.mName ? _model.mName:NODATA;
            dept = _model.mDept ? _model.mDept:NODATA;
            major = _model.mMajor ? _model.mMajor:NODATA;
        }
        //头像图片
        UIImageView *headImgView  = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 80, 120)];
        headImgView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:headImgView];
        
        //姓名
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 200, 30)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:20];
        nameLabel.textColor = RGBACOLOR(0, 140, 207, 1);
        nameLabel.text = name;
        [cell.contentView addSubview:nameLabel];
        
        //学校名称
        UILabel *schoolLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 40, 200, 50)];
        schoolLabel.backgroundColor = [UIColor clearColor];
        schoolLabel.numberOfLines = 2;
        schoolLabel.lineBreakMode = UILineBreakModeWordWrap;
        schoolLabel.font = [UIFont boldSystemFontOfSize:20];
        schoolLabel.text = dept;
        [cell.contentView addSubview:schoolLabel];
        
        //专业名称
        UILabel *specialityLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 80, 200, 50)];
        specialityLabel.backgroundColor = [UIColor clearColor];
        specialityLabel.numberOfLines = 2;
        specialityLabel.lineBreakMode = UILineBreakModeWordWrap;
        specialityLabel.font = [UIFont boldSystemFontOfSize:20];
        specialityLabel.text = major;
        [cell.contentView addSubview:specialityLabel];
    }
    else if (indexPath.section == 1&&indexPath!=0) //个人履历
    {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonInfoCell" owner:nil options:nil] objectAtIndex:0];
        PersonInfoCell *personInfoCell = [[PersonInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier profileModel:[self.timeLimeArray objectAtIndex:indexPath.row]];
        cell = personInfoCell;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(indexPath.section == 2||indexPath.section == 3) //个人关注||//关注我的人
    {
        int type = indexPath.section ==2?myNoticeListType:NoticeMeListType;
        int coutn = indexPath.section==2?myNoticeCount:NoticeMeCount;
        
        if (type == 1)
        {
            
            int rowCount = coutn%3==0?coutn/3:coutn/3+1;
            int currentLineCount ;
            if (coutn%3 == 0)
            {
                currentLineCount = 3;
            }
            else
            {
                if (indexPath.row<rowCount)
                {
                    currentLineCount = 3;
                }
                else
                {
                    currentLineCount = coutn%3;
                }
            }
            
            for (int i=0; i<currentLineCount; i++)
            {
                PersonHeadView *personHeadView = [[PersonHeadView alloc]initWithFrame:CGRectMake(8*(i+1)+i*90, 5, 90, 120)];
                personHeadView.nameLabel.text = @"文彬";
                personHeadView.headImgBtn.tag = 201; //TODO: 暂时写死
                [personHeadView.headImgBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:personHeadView];
            }

            
        }
        else
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonCell" owner:nil options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            PersonCell *pesonCell = (PersonCell*)cell;
            pesonCell.headImg.tag =200; //TODO 暂时写死
            [pesonCell.headImg addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
            [pesonCell.actionBtn setTitle:indexPath.section==2?@"取消关注":@"关注" forState:UIControlStateNormal];
        }
        
        
    }
  
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1&&self.pageType == 0) //进入相关推荐页面
    {
        CommendListViewController *commendListController = [[CommendListViewController alloc]initWithNibName:@"CommendListViewController" bundle:[NSBundle mainBundle]];
        AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appdelegate.rootNavigationController pushViewController:commendListController animated:YES];

    }
}

- (void)refreshData
{
    //获取个人信息
    AFHTTPRequestOperation *operation1 = [[Transfer sharedTransfer] TransferWithRequestDic:nil
        requesId:@"PROFILE_BASIC"
        prompt:@"prompt"
     replaceId:@"me"
        success:^(id obj) {
          
          if ([[obj objectForKey:@"rc"]intValue] == 1) {
              NSDictionary *basicDic = [obj objectForKey:@"basic"];
              _model = [[ProfileModel alloc] init];
              [_model setMAdYear:[basicDic objectForKey:@"adYear"]];
              NSNumberFormatter *fomatter = [[NSNumberFormatter alloc] init];
              [_model setMGender:[fomatter stringFromNumber:[basicDic objectForKey:@"gender"]]];
              [_model setMMajor:[basicDic objectForKey:@"major"]];
              [_model setMName:[basicDic objectForKey:@"name"]];
              [_model setMDept:[basicDic objectForKey:@"dept"]];
              
          }
          
          [self.listTableView performSelectorInBackground:@selector(reloadData) withObject:nil];
        }
        failure:^(NSString *errMsg) {
          
        }];
    
    // 查看个人履历
    AFHTTPRequestOperation *operation2 = [[Transfer sharedTransfer] TransferWithRequestDic:nil
         requesId:@"TIMELINE_LIST"
           prompt:@"prompt"
        replaceId:@"me"
          success:^(id obj) {
              
              if ([[obj objectForKey:@"rc"]intValue] == 1) {
                  NSArray *list = [obj objectForKey:@"list"];
                  for (id obj2 in list) {
                      ProfileModel *model = [[ProfileModel alloc] init];
                      [model setMCity:[obj2 objectForKey:@"city"]];
                      [model setMDesc:[obj2 objectForKey:@"desc"]];
                      [model setMEtime:[obj2 objectForKey:@"etime"]];
                      [model setMStime:[obj2 objectForKey:@"stime"]];
                      [model setMProvince:[obj2 objectForKey:@"province"]];
                      [model setMOrg:[obj2 objectForKey:@"org"]];
                      [self.timeLimeArray addObject:model];
                  }
                  
              }
              [self.listTableView performSelectorInBackground:@selector(reloadData) withObject:nil];
          }
          failure:^(NSString *errMsg) {
              
          }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation1, operation2, nil] prompt:@"正在获取数据..." completeBlock:^(NSArray *operations) {
        
        
        
    }];
}

@end
