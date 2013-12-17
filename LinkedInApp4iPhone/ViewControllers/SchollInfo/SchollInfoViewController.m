//
//  SchollInfoViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "SchollInfoViewController.h"
#import "ListCell.h"
#import "DetailInfoViewController.h"
#import "MessageListViewController.h"
#import "SchollCardApplyViewController.h"
#import "BDViewController.h"

@interface SchollInfoViewController ()
{
    int schollInfoTotalCount;   //母校动态信息条数
}
@end

@implementation SchollInfoViewController

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
    self.navigationItem.title = @"母校信息";
    
    self.listTableView.backgroundView = nil;
    
    [self getSchollInfoListInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--功能函数
/**
 *  跳转到详情页面
 *
 *  @param idStr 新闻id
 */
- (void)gotoDetailPageWithID:(NSString*)idStr type:(int)type
{
    DetailInfoViewController *detailController = [[DetailInfoViewController alloc]initWithNibName:@"DetailInfoViewController" bundle:Nil];
    detailController.listId = idStr;
    detailController.typeId = [NSString stringWithFormat:@"%d",type];
    [self.navigationController pushViewController:detailController animated:YES];
    
}
#pragma mark-
#pragma mark--发送http请求
/**
 *  获取母校动态信息
 */
- (void)getSchollInfoListInfo
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"page":@"1",@"num":@"5",@"previewLen":@"50",@"type":[NSString stringWithFormat:@"%d",3]} requesId:@"CUSTOMEMEDIOLISTINFO" messId:nil success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 NSArray *listArray = obj[@"list"];
      
                                                 schollInfoTotalCount = [obj[@"total"] intValue];
                                                 self.schoolInfoMtbArray = [NSMutableArray arrayWithCapacity:0];
                                                 
                                                 for (int i=0; i< listArray.count; i++)
                                                 {
                                                     NSDictionary *temDict = listArray[i];
                                                     ProfileModel *model = [[ProfileModel alloc]init];
                                                     model.mDesc = temDict[@"preview"];
                                                     model.mImgUrl = temDict[@"pic"];
                                                     model.mId = temDict[@"id"];
                                                     
                                                    
                                                    [self.schoolInfoMtbArray addObject:model];
                                                     
                                                 }
                                                 
                                                 [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                                                 
                                             }
                                             else if([[obj objectForKey:@"rc"]intValue] == -1)
                                             {
                                                  [SVProgressHUD showErrorWithStatus:@"母校动态加载失败"];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"母校动态加载失败"];
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
        case 100: //母校动态查看更多
        {
            MessageListViewController *messageListController = [[MessageListViewController alloc]init];
            messageListController.type = 3;
            [self.navigationController pushViewController:messageListController animated:YES];
        }
            break;
        case 101: //印象首师查看更多
        {
            BDViewController *bcViewController = [[BDViewController alloc]init];
            [self.navigationController pushViewController:bcViewController animated:YES];
        }
            break;
        case 102: //我要捐赠
        {
            SchollCardApplyViewController *schoolCardApplyController = [[SchollCardApplyViewController alloc]init];
            schoolCardApplyController.pageType = 1;
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return self.schoolInfoMtbArray.count;
    }
 
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1||indexPath.section == 2)
    {
        return indexPath.row == 0?44:150;
    }
    else if(indexPath.section == 3)
    {
        return indexPath.row == 0?44:100;
    }
    else if(indexPath.section == 0)
    {
        return indexPath.row == 0?44:90;
    }
    
    return 90;
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
    
    if (indexPath.row == 0) //section组别标题
    {
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
            titleStr = @"母校动态";
            
        }
        else if(indexPath.section == 1)
        {
            titleStr = @"印象首师";
         
        }
        else if(indexPath.section == 2)
        {
            dtailStr = @"我要捐赠";
            titleStr = @"校友捐赠";
          
        }
        else if(indexPath.section == 3)
        {
            titleStr = @"数据母校";
           
        }
        
        titleLabel.text = titleStr;
        [cell.contentView addSubview:titleLabel];
        
        //右侧操作按钮
        
        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        detailBtn.frame = CGRectMake(tableView.frame.size.width-130, 5, 100, 35);
        [detailBtn setBackgroundImage:[UIImage imageNamed:detailImg] forState:UIControlStateNormal];
        [detailBtn setBackgroundImage:[UIImage imageNamed:detailPressImg] forState:UIControlStateHighlighted];
        
        
        detailBtn.tag = 100+indexPath.section;
        [detailBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        [detailBtn setTitle:dtailStr forState:UIControlStateNormal];
        
        if (indexPath.section==0&&schollInfoTotalCount>3)
        {
            [cell.contentView addSubview:detailBtn];
        }
        
        [cell.contentView addSubview:detailBtn]; //TODO
        return cell;
    }
    
    if (indexPath.section==0)
    {
        ListCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:nil options:nil] objectAtIndex:0];
        
        ProfileModel *model = self.schoolInfoMtbArray[indexPath.row];
        [cell.headImgView setImageWithURL:[NSURL URLWithString:model.mImgUrl ] placeholderImage:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
        cell.txtLabel.text = model.mDesc;

        return cell;
    }
    else if(indexPath.section == 1)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        button.frame = CGRectMake(5, 5, tableView.frame.size.width-10, 140);
        [cell.contentView addSubview:button];
        return cell;
    }
    else if(indexPath.section == 2)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        button.frame = CGRectMake(5, 5, tableView.frame.size.width-10, 140);
        [cell.contentView addSubview:button];
        return cell;
    }
    else if(indexPath.section == 3)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //学校图片
        UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 100, 70)];
        headImgView.backgroundColor = [UIColor grayColor];
       
        //[headImgView setImageWithURL:[NSURL URLWithString:self.schollInfoModel.mImgUrl] placeholderImage:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
        headImgView.layer.borderColor = [UIColor grayColor].CGColor;
        headImgView.layer.borderWidth = 2;
        [cell.contentView addSubview:headImgView];
        
        //学校名称
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 200, 90)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.numberOfLines = 0;
        nameLabel.lineBreakMode = UILineBreakModeWordWrap;
        nameLabel.textColor = RGBACOLOR(0, 140, 207, 1);
        nameLabel.font = [UIFont boldSystemFontOfSize:16];
        nameLabel.text = @"学校名称";
        [cell.contentView addSubview:nameLabel];
        
        //学校详情
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, nameLabel.frame.origin.y+nameLabel.frame.size.height+5, 180, 100-10-nameLabel.frame.size.height)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:15];
        detailLabel.lineBreakMode = UILineBreakModeTailTruncation;
        detailLabel.numberOfLines = 6;
        detailLabel.text = @"detail";
        [cell.contentView addSubview:detailLabel];
        
        return cell;

    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) //母校动态
    {
        ProfileModel *model = self.schoolInfoMtbArray[indexPath.row];
        [self gotoDetailPageWithID:model.mId type:3];
    }
}

@end
