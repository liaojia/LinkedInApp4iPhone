//
//  NoticeViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "NoticeListViewController.h"
#import "NoticeDetailViewController.h"

#define Tag_AddMore_Action 100

@interface NoticeListViewController ()

@end

@implementation NoticeListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.listMtbArray = [[NSMutableArray alloc]initWithCapacity:0];
        currentPage = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"公告列表";
    [self initTableview];
    
    [self getBroadcastListWithPage:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setListTableView:nil];
    [super viewDidUnload];
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
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    moreBtn.frame  = CGRectMake(20, 5, 280, 30);
    [moreBtn setTitle:@"点击加载更多" forState:UIControlStateNormal];
    moreBtn.tag = Tag_AddMore_Action;
    [moreBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:moreBtn];
    self.listTableView.tableFooterView = footView;
    
    
}

/**
 *	@brief	获取公告列表
 */
- (void)getBroadcastListWithPage:(int)page
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"page":[NSString stringWithFormat:@"%d",page],@"num":@"5",@"previewLen":@"50"} requesId:@"COLLEGE_BROADCAST_LIST" messId:nil success:^(id obj)
     {
         if ([[obj objectForKey:@"rc"]intValue] == 1)
         {
             currentPage++;
             totalCount = [obj[@"total"] intValue];
             NSArray *listArray = obj[@"list"];
             for (NSDictionary *temDict in listArray)
             {
                 ProfileModel *model = [[ProfileModel alloc]init];
                 model.mName = temDict[@"title"];
                 model.mStime = temDict[@"time"];
                 model.mDesc = temDict[@"preview"];
                 model.mId = temDict[@"id"];
                 [self.listMtbArray addObject:model];
                 [self.listTableView reloadData];
             }
             
             //没有更多信息
             
             if (self.listMtbArray.count>=totalCount)
             {
                 self.listTableView.tableFooterView.hidden = YES;
             }
         }
         else if([[obj objectForKey:@"rc"]intValue] == -1)
         {
             [SVProgressHUD showErrorWithStatus:@"未找到公告信息"];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"公告信息加载失败"];
         }
         
         
     } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
                                   completeBlock:nil];
    
    
}

#pragma mark-
#pragma mark--按钮点击相关
- (void)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case Tag_AddMore_Action:
        {
            [self getBroadcastListWithPage:currentPage+1];
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
 
    return self.listMtbArray.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 110;
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
   // cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    ProfileModel *model = self.listMtbArray[indexPath.row];
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5,280 , 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = RGBACOLOR(0, 140, 207, 1);
    titleLabel.text = model.mName;
    [cell.contentView addSubview:titleLabel];
    
    //详细
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35,300 , 40)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont systemFontOfSize:17];
    detailLabel.numberOfLines = 2;
    detailLabel.lineBreakMode = UILineBreakModeTailTruncation;
    detailLabel.text = model.mDesc;
    [cell.contentView addSubview:detailLabel];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 75,100 , 30)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = UITextAlignmentRight;
    timeLabel.text = model.mStime;
    [cell.contentView addSubview:timeLabel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeDetailViewController *noticeDetailController = [[NoticeDetailViewController alloc]initWithNibName:@"NoticeDetailViewController" bundle:[NSBundle mainBundle]];
    ProfileModel *temModel = self.listMtbArray[indexPath.row];
    noticeDetailController.idStr = [NSString stringWithFormat:@"%@",temModel.mId];
    [self.navigationController pushViewController:noticeDetailController animated:YES];
}
@end
