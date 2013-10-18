//
//  NoticeDetailViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-18.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "NoticeDetailViewController.h"

@interface NoticeDetailViewController ()

@end

@implementation NoticeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.detalModel = [[ProfileModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"公告详情";
    self.listTableView.tableFooterView = [[UIView alloc]init];
    
    [self getBroadCastDetailWithID:self.idStr];
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


/**
 *	@brief	获取公告详情
 *
 *	@param 	idStr 	公告id
 */
- (void)getBroadCastDetailWithID:(NSString*)idStr

{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:nil requesId:@"COLLEGE_BROADCAST_DETAIL" messId:idStr success:^(id obj)
     {
         if ([[obj objectForKey:@"rc"]intValue] == 1)
         {
                         
             self.detalModel.mDesc = obj[@"content"];
             self.detalModel.mName = obj[@"title"];
             self.detalModel.mStime = obj[@"time"];
             
             [self.listTableView reloadData];
         }
         else if([[obj objectForKey:@"rc"]intValue] == -1)
         {
             [SVProgressHUD showErrorWithStatus:@"id不存在！"];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"公告信息加载失败！"];
         }
         
         
     } failure:nil];

    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
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
    
    return 2;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        return [StaticTools getLabelHeight:self.detalModel.mName defautWidth:280 defautHeight:1000 fontSize:20]+30;
    }
    
    return [StaticTools getLabelHeight:self.detalModel.mDesc defautWidth:300 defautHeight:10000 fontSize:17];
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
    
    if (indexPath.row == 0)
    {
        //标题
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5,280 , [StaticTools getLabelHeight:self.detalModel.mName defautWidth:280 defautHeight:1000 fontSize:20])];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.text = self.detalModel.mName;
        [cell.contentView addSubview:titleLabel];
        
        //时间
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.frame.origin.y+titleLabel.frame.size.height,300 , 30)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor =  RGBACOLOR(0, 140, 207, 1);
        timeLabel.font = [UIFont systemFontOfSize:17];
        timeLabel.textAlignment = UITextAlignmentRight;
        timeLabel.text = self.detalModel.mStime;
        [cell.contentView addSubview:timeLabel];
    }
    else
    {
        //详细
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5,300 , [StaticTools getLabelHeight:self.detalModel.mDesc defautWidth:300 defautHeight:10000 fontSize:17])];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:17];
        detailLabel.numberOfLines = 0;
        detailLabel.lineBreakMode = UILineBreakModeWordWrap;
        detailLabel.text = self.detalModel.mDesc;
        [cell.contentView addSubview:detailLabel];
    }

    

    return cell;
}

@end
