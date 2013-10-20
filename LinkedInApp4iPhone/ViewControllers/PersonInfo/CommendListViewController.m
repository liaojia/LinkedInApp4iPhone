//
//  CommendListViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "CommendListViewController.h"
#import "PersonHeadView.h"
#import "PersonCell.h"
#define Tag_ChangeShowType_Action 100
#define Tag_AddMore_Action        101

@interface CommendListViewController ()

@end

@implementation CommendListViewController

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
    self.navigationItem.title = @"相关推荐";
    
    personCount = [self.mArray count];
    currentPate = 1;
    [self initTableview];
}
- (void)viewDidUnload
{
    [self setListTable:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--功能函数
/**
 *	@brief	初始化tableview相关
 */
- (void)initTableview
{
    //初始化tablview的headview
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    headView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"相关推荐";
    [headView addSubview:titleLabel];
    
    UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    typeBtn.frame = CGRectMake(260, 5, 35, 35);
    typeBtn.tag = Tag_ChangeShowType_Action;
    [typeBtn setImage:[UIImage imageNamed:@"img_card_list_two"] forState:UIControlStateNormal];
    [typeBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:typeBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:lineView];
    self.listTable.tableHeaderView = headView;
    
    
    //初始化tablview 的footview
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    moreBtn.frame  = CGRectMake(20, 5, 280, 30);
    [moreBtn setTitle:@"点击加载更多" forState:UIControlStateNormal];
    moreBtn.tag = Tag_AddMore_Action;
    [moreBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:moreBtn];
    self.listTable.tableFooterView = footView;
    
    [self refreshData];
}

#pragma mark-
#pragma mark--按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Tag_ChangeShowType_Action : //改变列表展示类型
        {
            pageType = pageType==0?1:0;
            UIButton *button = (UIButton*)[self.listTable.tableHeaderView viewWithTag:Tag_ChangeShowType_Action];
            [button setImage:[UIImage imageNamed:pageType == 0?@"img_card_list_two":@"img_card_list_one"] forState:UIControlStateNormal];
            [self.listTable reloadData];
        }
            break;
        case Tag_AddMore_Action: //点击加载更多
        {
            personCount+=10;
            [self.listTable reloadData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (pageType == 0)
    {
        return personCount;
    }
    if (personCount%3==0)
    {
        return personCount/3;
    }
    else
    {
        return personCount/3+1;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return pageType == 0?100:130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (pageType == 0)
    {        
        static NSString *GridCellIentifier = @"GridIdentifier";
        PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:GridCellIentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonCell" owner:nil options:nil]objectAtIndex:0];
        }
        
        ProfileModel *model = [self.mArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.actionBtn.hidden = YES;
        cell.nameLabel.text = model.mName;
        cell.sexLabel.text = model.mGender;
        cell.placeLabel.text = [NSString stringWithFormat:@"%@--%@", model.mProvince, model.mCity];
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier =  @"CellIdentifier";
        
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
        
        int rowCount = personCount%3==0?personCount/3:personCount/3+1;
        int currentLineCount ;
        if (personCount%3 == 0)
        {
            currentLineCount = 3;
        }
        else
        {
            if (indexPath.row<rowCount-1)
            {
                currentLineCount = 3;
            }
            else
            {
                currentLineCount = personCount%3;
            }
        }
        
        for (int i=0; i<currentLineCount; i++)
        {
            PersonHeadView *personHeadView = [[PersonHeadView alloc]initWithFrame:CGRectMake(12*(i+1)+i*90, 5, 90, 120)];
            personHeadView.nameLabel.text = @"文彬";
            [cell.contentView addSubview:personHeadView];
        }
        return cell;
    }
   

  return nil;
}

-(void)refreshData
{
    switch (self.fromFlag) {
        case 0:
            
            break;
        case 1://个人关注
            [self getMyNoticeList];
            break;
        case 2://关注我的人
            [self getNoticeMeList];
            break;
        default:
            break;
    }
}

/**
 *	@brief 我关注的人列表
 */
-(void)getMyNoticeList

{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: @"1",@"page", [NSString stringWithFormat:@"%@", kPAGESIZE*4], @"num", nil];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:dic requesId:@"MYATTENTIONS_LIST" messId:nil success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 [self.mArray removeAllObjects];
                                                 NSArray *list = [obj objectForKey:@"list"];
                                                 for (id obj2 in list) {
                                                     ProfileModel *model = [[ProfileModel alloc] init];
                                                     [model setMCity:[obj2 objectForKey:@"city"]];
                                                     [model setMDesc:[obj2 objectForKey:@"desc"]];
                                                     [model setMEtime:[obj2 objectForKey:@"etime"]];
                                                     [model setMStime:[obj2 objectForKey:@"stime"]];
                                                     [model setMProvince:[obj2 objectForKey:@"province"]];
                                                     [model setMOrg:[obj2 objectForKey:@"org"]];
                                                     [model setMName:[obj2 objectForKey:@"name"]];
                                                     [model setMGender:[obj2 objectForKey:@"gender"]];
                                                     [model setMId:[obj2 objectForKey:@"id"]];
                                                     [self.mArray addObject:model];
                                                 }
                                                 [self.listTable reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -1)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"id不存在！"];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"加载失败！"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];
}

/**
 *	@brief 关注我的人列表
 */
-(void)getNoticeMeList

{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: @"1",@"page", [NSString stringWithFormat:@"%@", kPAGESIZE], @"num", nil];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:dic requesId:@"FANS_LIST" messId:nil success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 NSArray *list = [obj objectForKey:@"list"];
                                                 for (id obj2 in list) {
                                                     ProfileModel *model = [[ProfileModel alloc] init];
                                                     [model setMCity:[obj2 objectForKey:@"city"]];
                                                     [model setMDesc:[obj2 objectForKey:@"desc"]];
                                                     [model setMEtime:[obj2 objectForKey:@"etime"]];
                                                     [model setMStime:[obj2 objectForKey:@"stime"]];
                                                     [model setMProvince:[obj2 objectForKey:@"province"]];
                                                     [model setMOrg:[obj2 objectForKey:@"org"]];
                                                     [model setMName:[obj2 objectForKey:@"name"]];
                                                     [model setMGender:[obj2 objectForKey:@"gender"]];
                                                     [model setMId:[obj2 objectForKey:@"id"]];
                                                     [self.mArray addObject:model];
                                                 }
                                                 [self.listTable reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -1)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"id不存在！"];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"加载失败！"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];
}

/**
 *	@brief	加关注
 *
 *	@param 	personId 	人员ID（必填项）
 */
-(void)addNoticeWithId:(NSString *)personId

{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:nil requesId:@"ADD_ATTENTION" messId:personId success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 [self getMyNoticeList];
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -1)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"id不存在！"];
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -2){
                                                 [SVProgressHUD showErrorWithStatus:@"已经关注过此人！"];
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -3){
                                                 [SVProgressHUD showErrorWithStatus:@"关注对象非法！"];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"加载失败！"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];
}

/**
 *	@brief	取消关注
 *
 *	@param 	personId 	人员ID（必填项）
 */
-(void)cancelNoticeWithId:(NSString *)personId

{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:nil requesId:@"CANCELATTENTION" messId:personId success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 [self getMyNoticeList];
                                                 
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -1)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"id不存在！"];
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -2){
                                                 [SVProgressHUD showErrorWithStatus:@"没有关注过此人！"];
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -3){
                                                 [SVProgressHUD showErrorWithStatus:@"关注对象非法！"];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"加载失败！"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];
}
@end
