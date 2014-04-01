//
//  CircleMemberListViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-29.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "CircleMemberListViewController.h"
#import "PersonInfoCell.h"

@interface CircleMemberListViewController ()

@end

@implementation CircleMemberListViewController

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
    self.navigationItem.title = @"成员列表";
    
    self.resultMtbArray = [NSMutableArray arrayWithCapacity:0];
    
    [self initTableview];
    
    [self getCircleMemberListWithPage:1];
    
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
 *	@brief	初始化tableview相关
 */
- (void)initTableview
{
    //初始化tablview 的footview
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    footView.backgroundColor = [UIColor clearColor];
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame  = CGRectMake(20, 5, 280, 30);
    [moreBtn setTitle:@"点击加载更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:RGBACOLOR(0, 140, 207, 1) forState:UIControlStateNormal];
    moreBtn.layer.borderColor = RGBACOLOR(0, 140, 207, 1).CGColor;
    moreBtn.layer.borderWidth = 1;
    moreBtn.tag = 99;
    [moreBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:moreBtn];
    self.listTableView.tableFooterView = footView;
    self.listTableView.tableFooterView.hidden = YES;
    
    
}

- (void)buttonClickHandle:(id)sender
{
    [self getCircleMemberListWithPage:currentPage+1];
}
- (void)moveBtnClick:(UIButton*)button
{
     ProfileModel *model = self.resultMtbArray[button.tag-100];
    [self moveMenberWithId:model.mId];
    
}
#pragma mark-
#pragma mark--发送http请求
/**
 *	@brief	获取成员列表
 *
 *	@param
 */
-(void)getCircleMemberListWithPage:(int)page
{
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"page":[NSString stringWithFormat:@"%d",page],@"num":kPAGESIZE} requesId:@"GETCIRCLEMEMBERLIST" messId:self.circleId success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 currentPage++;
                                                 
                                                int listTotalCount = [[obj objectForKey:@"total"]intValue];
                                                 if (listTotalCount==0)
                                                 {
                                                     [SVProgressHUD showErrorWithStatus:@"圈子暂时还没有任何成员！"];
                                                     return ;
                                                 }
                                                 for ( NSDictionary *dict in obj[@"list"])
                                                 {
                                                     ProfileModel *model = [[ProfileModel alloc]init];
                                                     model.mName = dict[@"name"];
                                                     model.mGender = dict[@"gender"];
                                                     model.mOrg = dict[@"title"];
                                                     model.mProvince = dict[@"province"];
                                                     model.mCity = dict[@"city"];
                                                     model.mImgUrl = dict[@"pic"];
                                                     model.mId = dict[@"id"];
                                                     [self.resultMtbArray addObject:model];
                                                     
                                                 }
                                                 if (self.resultMtbArray.count>=listTotalCount)
                                                 {
                                                     self.listTableView.tableFooterView.hidden = YES;
                                                 }
                                                 else
                                                 {
                                                     self.listTableView.tableFooterView.hidden = NO;
                                                 }
                                                 
                                                 
                                                 [self.listTableView reloadData];
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -1)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"圈子id不存在！"];
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
 *  移除某个人
 *
 *  @param idStr 要移除成员的id
 */
- (void)moveMenberWithId:(NSString*)idStr
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:nil requesId:@"MOVEMYCIRCLEMENBER" messId:[NSString stringWithFormat:@"%@###%@",self.circleId,idStr] success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 [SVProgressHUD showSuccessWithStatus:@"移除成功!"];
                                                 
                                                 currentPage=0;
                                                 [self getCircleMemberListWithPage:1];
                                                 [self.resultMtbArray removeAllObjects];
                                                 [self.listTableView reloadData];
                                                 
                                                
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -1)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"圈子id不存在！"];
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -2)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"成员id不存在！"];
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -3)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"该人员不是圈子成员！"];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"删除除失败！"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];

}
#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultMtbArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    PersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonInfoCell" owner:nil options:nil]objectAtIndex:0];;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (self.pageType==0)
    {
        cell.changeBtn.hidden = NO;
        cell.changeBtn.frame = CGRectMake(250, 40, 60, 30);
        cell.changeBtn.tag = indexPath.row+100;
        [cell.changeBtn setTitle:@"删除" forState:UIControlStateNormal];
        [cell.changeBtn addTarget:self action:@selector(moveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
         cell.changeBtn.hidden = YES;
    }
   
    cell.recommendButton.hidden = YES;
    cell.recommendButton.hidden = YES;
    
    ProfileModel *model = self.resultMtbArray[indexPath.row];
    cell.timeLabel.text = model.mName;
    cell.placeLabel.text =model.mGender ;
    
    
    cell.orgLabel.text = [NSString stringWithFormat:@"%@\n%@--%@",model.mOrg,model.mProvince,model.mCity];
    [cell.headImgView setImageWithURL:[NSURL URLWithString:model.mImgUrl] placeholderImage:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
@end
