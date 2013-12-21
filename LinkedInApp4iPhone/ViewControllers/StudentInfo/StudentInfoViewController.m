//
//  StudentInfoViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "StudentInfoViewController.h"
#import "ListCell.h"
#import "DetailInfoViewController.h"
#import "SchollCardApplyViewController.h"
#import "MessageListViewController.h"

@interface StudentInfoViewController ()

@end

@implementation StudentInfoViewController

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
    self.listTableView.backgroundView = nil;
    self.listTableView.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"校友信息";
    
    [self getListInfoWithType:1];
    [self getListInfoWithType:2];
    
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
#pragma mark--发送http请求
/**
 *  获取校友动态信息||获取公告信息
 */
- (void)getListInfoWithType:(int)type
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"page":@"1",@"num":@"5",@"previewLen":@"50",@"type":[NSString stringWithFormat:@"%d",type]} requesId:@"CUSTOMEMEDIOLISTINFO" messId:nil success:^(id obj)
                             {
                                 if ([[obj objectForKey:@"rc"]intValue] == 1)
                                 {
                                     NSArray *listArray = obj[@"list"];
                                    
                                     
                                     if (type == 1)
                                     {
                                          self.studentInfoTotalCount = [obj[@"total"] intValue];
                                          self.studentInfoMtbArray = [NSMutableArray arrayWithCapacity:0];
                                     }
                                     else if(type == 2)
                                     {
                                        self.noticeInfoTotalCount = [obj[@"total"] intValue];
                                         self.noticeInfoMtbArray = [NSMutableArray arrayWithCapacity:0];
                                     }
                                    
                                     
                        
                                     for (int i=0; i< listArray.count; i++)
                                     {
                                         NSDictionary *temDict = listArray[i];
                                         ProfileModel *model = [[ProfileModel alloc]init];
                                         model.mDesc = temDict[@"preview"];
                                         model.mImgUrl = temDict[@"pic"];
                                         model.mId = temDict[@"id"];
                                         model.mTitle = temDict[@"title"];
                                         
                                         if (type==1) //校友动态
                                         {
                                             [self.studentInfoMtbArray addObject:model];
                                         }
                                         else if(type == 2) //通知公告
                                         {
                                             [self.noticeInfoMtbArray addObject:model];
                                         }
                                         
                                         
                                     }
                                     
                                     [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:type==1?0:1] withRowAnimation:UITableViewRowAnimationFade];
                                     
                                 }
                                 else if([[obj objectForKey:@"rc"]intValue] == -1)
                                 {
                                     [SVProgressHUD showErrorWithStatus:type==1? @"未找到校友动态信息":@"未找到通知公告信息"];
                                 }
                                 else
                                 {
                                     [SVProgressHUD showErrorWithStatus:type == 1? @"校友动态加载失败":@"通知公告加载失败"];
                                 }
                                 
                                 
                             } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
                                   completeBlock:nil];
}

#pragma mark-
#pragma mark--按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case 100: //校友动态查看更多
        {
            MessageListViewController *messageListController = [[MessageListViewController alloc]init];
            messageListController.type = 1;
            [self.navigationController pushViewController:messageListController animated:YES];
        }
            break;
        case 101: //通知公告查看更多
        {
            MessageListViewController *messageListController = [[MessageListViewController alloc]init];
            messageListController.type = 2;
            [self.navigationController pushViewController:messageListController animated:YES];
        }
            break;
        case 102: //申请校友龙卡
        {
            SchollCardApplyViewController *schoolCardApplyController = [[SchollCardApplyViewController alloc]init];
            [self.navigationController pushViewController:schoolCardApplyController animated:YES];
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
    if (section==0)
    {
        return (self.studentInfoMtbArray.count>3?3:self.studentInfoMtbArray.count)+1;
    }
    else if(section == 1)
    {
        return (self.noticeInfoMtbArray.count>3?3:self.noticeInfoMtbArray.count)+1;
    }
    else if(section == 2)
    {
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        return indexPath.row == 0?44:80;
    }
    else
    {
        return indexPath.row == 0?44:90;
    }
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==Nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   

    if (indexPath.row == 0) //section组别标题
    {
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        //左侧标题文字
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, 100, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font  = [UIFont boldSystemFontOfSize:18];
        NSString *titleStr;
        NSString *dtailStr = @"查看更多";
        NSString *detailImg;
        NSString *detailPressImg;
        
        detailImg = @"img_school_notice_normal";
        detailPressImg = @"img_school_notice_pressed";
        
        if (indexPath.section == 0)
        {
            titleStr = @"校友动态";
     
        }
        else if(indexPath.section == 1)
        {
            titleStr = @"通知公告";
        }
        else if(indexPath.section == 2)
        {
            dtailStr = @"我要申请";
            titleStr = @"校友龙卡";
        }
        
        titleLabel.text = titleStr;
        titleLabel.textColor = RGBCOLOR(29, 60, 229);
        [cell.contentView addSubview:titleLabel];
        
        //右侧操作按钮
      
        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        detailBtn.frame = CGRectMake(tableView.frame.size.width-130, 5, 100, 35);
        [detailBtn setBackgroundImage:[UIImage imageNamed:detailImg] forState:UIControlStateNormal];
        [detailBtn setBackgroundImage:[UIImage imageNamed:detailPressImg] forState:UIControlStateHighlighted];
        
        
        detailBtn.tag = 100+indexPath.section;
        [detailBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        [detailBtn setTitle:dtailStr forState:UIControlStateNormal];
        
        if ((indexPath.section==0&&self.studentInfoTotalCount>3)||
            (indexPath.section==1&&self.noticeInfoTotalCount>3)||
            indexPath.section == 2)
        {
            [cell.contentView addSubview:detailBtn];
        }
        
        [cell.contentView addSubview:detailBtn]; //TODO 暂时一直放着
        
        
        return cell;
    }
    
    if(indexPath.section == 2) //校友龙卡
    {
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        if (indexPath.row == 1)
        {
            UIButton *leftCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            leftCardBtn.frame = CGRectMake(5, 5, 140, 70);
            [leftCardBtn setBackgroundImage:[UIImage imageNamed:@"img_school_card_back"] forState:UIControlStateNormal];
            [cell.contentView addSubview:leftCardBtn];
            
            UIButton *rightCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightCardBtn.frame = CGRectMake(155, 5, 140, 70);
            [rightCardBtn setBackgroundImage:[UIImage imageNamed:@"img_school_card_front"] forState:UIControlStateNormal];
            [cell.contentView addSubview:rightCardBtn];
            
            return cell;

        }
    }
    else
    {
        
        ProfileModel *model;
        if (indexPath.section == 0)
        {
            model = self.studentInfoMtbArray[indexPath.row-1];
        }
        else if(indexPath.section == 1)
        {
             model = self.noticeInfoMtbArray[indexPath.row-1];
        }
        
        [cell.headImgView setImageWithURL:[NSURL URLWithString:model.mImgUrl ] placeholderImage:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
        cell.txtLabel.text = model.mTitle;

       
        return cell;
        
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0||indexPath.section == 2)
    {
        return;
    }
    
    ProfileModel *model;
    if (indexPath.section == 0)
    {
        model = self.studentInfoMtbArray[indexPath.row-1];
    }
    else if(indexPath.section == 1)
    {
        model = self.noticeInfoMtbArray[indexPath.row-1];
    }
    
    DetailInfoViewController *detailController = [[DetailInfoViewController alloc]initWithNibName:@"DetailInfoViewController" bundle:[NSBundle mainBundle]];
    detailController.listId = [NSString stringWithFormat:@"%@",model.mId];
    detailController.typeId = [NSString stringWithFormat:@"%d",(indexPath.section==0?1:2)];
    [self.navigationController pushViewController:detailController animated:YES];
    
}
@end
