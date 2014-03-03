//
//  CircleInfoViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-29.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "CircleInfoViewController.h"
#import "PersonInfoCell.h"
#import "ReplyViewController.h"
#import "CircleMemberListViewController.h"

@interface CircleInfoViewController ()

@end

@implementation CircleInfoViewController

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
    self.navigationItem.title = @"圈子信息";
    self.listTableView.backgroundView = nil;
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.resultMtbArray = [NSMutableArray arrayWithCapacity:0];
    [self initTableview];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(280, 5, 70, 30);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightBtn.tag = 98;
    if (self.circleType==0)
    {
        [rightBtn setTitle:@"删除圈子" forState:UIControlStateNormal];
    }
    else if(self.circleType==1)
    {
        [rightBtn setTitle:@"退出圈子" forState:UIControlStateNormal];
    }
    else if(self.circleType==2)
    {
        [rightBtn setTitle:@"加入圈子" forState:UIControlStateNormal];
    }
    
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_find_stu_n"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_find_stu_s"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self getCircleMessListWithPage:1];
    
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

/**
 *  刷新列表  回复页面回复成功后调用
 */
- (void)freshList
{
    currentPage = 0;
    [self.resultMtbArray removeAllObjects];
    [self.listTableView reloadData];
    
    [self getCircleMessListWithPage:1];
}
#pragma mark-
#pragma mark--发送http请求
/**
 *	@brief	获取评论列表
 *
 *	@param
 */
-(void)getCircleMessListWithPage:(int)page
{

    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"page":[NSString stringWithFormat:@"%d",page],@"num":kPAGESIZE} requesId:@"CIRCLEMESSLIST" messId:[NSString stringWithFormat:@"%@",self.infoDict[@"id"]] success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 currentPage++;
                                                 
                                                 listTotalCount = [[obj objectForKey:@"total"]intValue];
                                                 [self.resultMtbArray addObjectsFromArray:obj[@"list"]];
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
 *  删除圈子
 */
- (void)deleteCirecle
{
    
       AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:nil requesId:@"DELETECIRCLE" messId:[NSString stringWithFormat:@"%@",self.infoDict[@"id"] ]success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"删除成功！"];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                                 if ([self.fatherController respondsToSelector:@selector(refreshMyCreateCricle)])
                                                 {
                                                     [self.fatherController performSelector:@selector(refreshMyCreateCricle) withObject:nil];
                                                 }
                                             }
                                             
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试！"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];
}
/**
 *  退出圈子
 */
- (void)getOutOfCirecle
{
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:nil requesId:@"GETOUTOFCIRCLE" messId:[NSString stringWithFormat:@"%@",self.infoDict[@"id"] ]success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"退出成功！"];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                                 if ([self.fatherController respondsToSelector:@selector(refreshMyCreateCricle)])
                                                 {
                                                     [self.fatherController performSelector:@selector(refreshMyCreateCricle) withObject:nil];
                                                 }
                                             }
                                             else if ([[obj objectForKey:@"rc"]intValue] == -1)
                                             {
                                                  [SVProgressHUD showErrorWithStatus:@"圈子不存在！"];
                                             }
                                             else if ([[obj objectForKey:@"rc"]intValue] == -2)
                                             {
                                                  [SVProgressHUD showErrorWithStatus:@"您没有加入过该圈子！"];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试！"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];
}

/**
 *  加入圈子
 */
- (void)joinCirecle
{
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:nil requesId:@"JOINCIRCLE" messId:[NSString stringWithFormat:@"%@",self.infoDict[@"id"] ]success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"加入圈子成功！"];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                                 if ([self.fatherController respondsToSelector:@selector(refreshMyCreateCricle)])
                                                 {
                                                     [self.fatherController performSelector:@selector(refreshMyCreateCricle) withObject:nil];
                                                 }
                                             }
                                             else if ([[obj objectForKey:@"rc"]intValue] == -1)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"圈子不存在！"];
                                             }
                                             else if ([[obj objectForKey:@"rc"]intValue] == -2)
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"您已经加入该圈子！"];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试！"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"数据加载中..."
                                   completeBlock:nil];
}


#pragma mark-
#pragma mark--按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button.tag>=200)
    {
        NSDictionary *dict = self.resultMtbArray[button.tag-200];
        ReplyViewController *replyController = [[ReplyViewController alloc]initWithNibName:@"ReplyViewController" bundle:Nil];
        replyController.cirecleId = [NSString stringWithFormat:@"%@",self.infoDict[@"id"]];
        replyController.resId = [NSString stringWithFormat:@"%@",dict[@"id"]];
        replyController.fatherController = self;
        [self.navigationController pushViewController:replyController animated:YES];
        
    }
    switch (button.tag)
    {
        case 100: //成员列表
        {
            CircleMemberListViewController *memberListContorller = [[CircleMemberListViewController alloc]initWithNibName:@"CircleMemberListViewController" bundle:nil];
            memberListContorller.pageType = self.circleType;
            memberListContorller.circleId =  [NSString stringWithFormat:@"%@",self.infoDict[@"id"]];
            [self.navigationController pushViewController:memberListContorller animated:YES];
        }
            break;
        case 101: //发表评论
        {
            ReplyViewController *replyController = [[ReplyViewController alloc]initWithNibName:@"ReplyViewController" bundle:Nil];
             replyController.cirecleId = [NSString stringWithFormat:@"%@",self.infoDict[@"id"]];
            replyController.fatherController = self;
            [self.navigationController pushViewController:replyController animated:YES];
            

        }
            break;
        case 99: //点击加载更多
        {
            [self getCircleMessListWithPage:currentPage+1];
        }
            break;
        case 98:
        {
            if (self.circleType==0) //删除圈子
            {
                [self deleteCirecle];
            }
            else if(self.circleType==1) //退出圈子
            {
                [self getOutOfCirecle];
            }
            else if(self.circleType==2)
            {
                [self joinCirecle];
            }
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section==0)
    {
        return 2;
        
    }
    else
    {
        return self.resultMtbArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return indexPath.row==0?44:35;
    }
    
    NSDictionary *dict = self.resultMtbArray[indexPath.row];
    return 90+[StaticTools getLabelHeight:dict[@"content"] defautWidth:145 defautHeight:480 fontSize:14];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = RGBACOLOR(188, 197, 230, 1);
    //左侧标题文字
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font  = [UIFont boldSystemFontOfSize:16];
    NSString *titleStr;
    NSString *dtailStr = @"查看更多";
    NSString *detailImg;
    NSString *detailPressImg;
    
    detailImg = @"img_school_notice_normal";
    detailPressImg = @"img_school_notice_pressed";
    
    if (section == 0)
    {
        titleStr = @"圈子信息";
        dtailStr = @"成员列表";
        
    }
    else if(section == 1)
    {
        titleStr = @"评论信息";
        dtailStr = @"发表评论";
    }
 
    titleLabel.text = titleStr;
    titleLabel.textColor = RGBCOLOR(29, 60, 229);
    [view addSubview:titleLabel];
    
    //右侧操作按钮
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.frame = CGRectMake(tableView.frame.size.width-100, 13, 70, 25);
    [detailBtn setBackgroundImage:[UIImage imageNamed:detailImg] forState:UIControlStateNormal];
    [detailBtn setBackgroundImage:[UIImage imageNamed:detailPressImg] forState:UIControlStateHighlighted];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    detailBtn.tag = 100+section;
    [detailBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [detailBtn setTitle:dtailStr forState:UIControlStateNormal];
    
    [view addSubview:detailBtn];
    
    return view;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    if (indexPath.section==0)
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
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 80, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 220, 44)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.numberOfLines = 2;
        detailLabel.lineBreakMode = UILineBreakModeTailTruncation;
        detailLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:detailLabel];
        
        if (indexPath.row==0)
        {
            titleLabel.text = @"圈子简介";
            detailLabel.text = self.infoDict[@"desc"];
            detailLabel.frame = CGRectMake(90, 5, 220, 35);
        }
        else if(indexPath.row == 1)
        {
            titleLabel.text = @"创建时间";
            detailLabel.text = self.infoDict[@"createTime"];
            titleLabel.frame = CGRectMake(5, 5, 80, 25);
            detailLabel.frame = CGRectMake(90, 5, 220, 25);
        }

    
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"CellIdenti";
        PersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonInfoCell" owner:nil options:nil] objectAtIndex:0];;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dict = self.resultMtbArray[indexPath.row];

        cell.recommendButton.hidden = YES;
        cell.timeLabel.text = dict[@"authorName"];
        cell.placeLabel.text = dict[@"content"];
        cell.orgLabel.text = dict[@"time"];
        [cell.headImgView setImageWithURL:[NSURL URLWithString:dict[@"authorPic"]] placeholderImage:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
        [cell.changeBtn setTitle:@"回复" forState:UIControlStateNormal];
        [cell.changeBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        cell.changeBtn.tag = 200+indexPath.row;
        
        [cell adjustControlFrame];
        return cell;
    }
    
    return nil;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
@end
