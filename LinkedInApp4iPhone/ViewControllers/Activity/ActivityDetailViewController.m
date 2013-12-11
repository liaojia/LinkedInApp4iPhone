//
//  ActivityDetailViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityCell.h"
#import "PersonHeadView.h"

#define Tag_AddMore_Action 100

@interface ActivityDetailViewController ()

@end

@implementation ActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.pepleListMtbArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"活动详情";

    [self initTableview];
    
    [self getActivityDetailWithID:self.idStr];
    [self getActPersonListWithID:self.idStr page:1];
    
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
#pragma mark--功能函数

#pragma mark-
#pragma mark--功能函数
/**
 *	@brief	初始化tableview相关
 */
- (void)initTableview
{
    self.listTableView.separatorColor = [UIColor clearColor];
    
    //初始化tablview 的footview
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    footView.backgroundColor = [UIColor clearColor];
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    moreBtn.frame  = CGRectMake(20, 5, 280, 30);
    [moreBtn setTitle:@"查看更多参加活动的人" forState:UIControlStateNormal];
    moreBtn.tag = Tag_AddMore_Action;
    [moreBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:moreBtn];
    self.listTableView.tableFooterView = footView;
    self.listTableView.tableFooterView.hidden  = YES;
    
    
}

/**
 *	@brief	获取活动详细
 *
 *	@param 	idStr 	活动id
 */
- (void)getActivityDetailWithID:(NSString*)idStr

{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:nil requesId:@"COLLEGE_EVENT_DETAIL" messId:idStr success:^(id obj)
         {
             if ([[obj objectForKey:@"rc"]intValue] == 1)
             {
                 self.actDetailModel = [[ProfileModel alloc]init];
                 self.actDetailModel.mDesc = obj[@"preview"];
                 self.actDetailModel.mName = obj[@"title"];
                 self.actDetailModel.mStime = obj[@"stime"];
                 self.actDetailModel.mPlace = obj[@"address"];
                 self.actDetailModel.mType = obj[@"typeID"];
                 self.actDetailModel.mMoney = obj[@"charge"];
                 self.actDetailModel.mSponsor = obj[@"sponsor"];
                 self.actDetailModel.mImgUrl = obj[@"pic"];
                 self.actDetailModel.mContent  = obj[@"content"];
                 [self.listTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationFade];
                 
             }
             else if([[obj objectForKey:@"rc"]intValue] == -1)
             {
                 [SVProgressHUD showErrorWithStatus:@"id不存在！"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"活动信息加载失败！"];
             }
             
             
         } failure:nil];

    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
                                   completeBlock:nil];

}

/**
 *	@brief	获取活动成员列表
 *
 *	@param 	idStr 	活动id
 */
- (void)getActPersonListWithID:(NSString*)idStr page:(int)page
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"page":[NSString stringWithFormat:@"%d",page],@"num":@"20"} requesId:@"COLLEGE_EVENT_PARTICIPANT_LIST" messId:idStr success:^(id obj)
         {
             if ([[obj objectForKey:@"rc"]intValue] == 1)
             {
                 currentPage++;
                 
                 
                 pepleCount = [obj[@"total"] intValue];
                 NSArray *list = obj[@"list"];
                 for (int i=0; i<list.count; i++)
                 {
                     NSDictionary *temDict = list[i];
                     ProfileModel *model = [[ProfileModel alloc]init];
                     model.mName = temDict[@"name"];
                     model.mId = temDict[@"id"];
                     model.mImgUrl = temDict[@"pic"];
                     [self.pepleListMtbArray addObject:model];
                 }
                 if (self.pepleListMtbArray.count>=pepleCount)
                 {
                     self.listTableView.tableFooterView.hidden = YES;
                 }
                 else
                 {
                     self.listTableView.tableFooterView.hidden  = NO;
                 }
                 
                 [self.listTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
                 
             }
             else if([[obj objectForKey:@"rc"]intValue] == -1)
             {
                 [SVProgressHUD showErrorWithStatus:@"id不存在！"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"成员信息加载失败！"];
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
            [self getActPersonListWithID:self.idStr page:currentPage+1];
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
    if (section ==0)
    {
        
        return self.actDetailModel==nil?0:1;
    }
    else if(section == 1)
    {
        return 2;
    }
    return self.pepleListMtbArray.count%4==0?self.pepleListMtbArray.count/4+1:self.pepleListMtbArray.count/4+2;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        float height;
        ProfileModel *model = self.actDetailModel;
        int desAndTitleHeight; //描述和题目的高度总和 若小于图片的高度 测返回图片的高度
        
        desAndTitleHeight  = [StaticTools getLabelHeight:model.mDesc defautWidth:135 defautHeight:1000 fontSize:17]+[StaticTools getLabelHeight:model.mName defautWidth:134 defautHeight:1000 fontSize:17];
        desAndTitleHeight = desAndTitleHeight<185?185:desAndTitleHeight;
        height+=desAndTitleHeight;
        height += [StaticTools getLabelHeight:model.mStime defautWidth:220 defautHeight:1000 fontSize:17];
        height += [StaticTools getLabelHeight:model.mPlace defautWidth:220 defautHeight:1000 fontSize:17];
        height += [StaticTools getLabelHeight:model.mType defautWidth:220 defautHeight:1000 fontSize:17];
        height += [StaticTools getLabelHeight:model.mMoney defautWidth:220 defautHeight:1000 fontSize:17];
        height += [StaticTools getLabelHeight:model.mSponsor defautWidth:220 defautHeight:1000 fontSize:17];
        
        return height;

    }
    else
    {
        if (indexPath.row == 0)
        {
            return 44;
        }
        else if(indexPath.section == 1&&indexPath.row == 1) //活动详情
        {
        
            return [StaticTools getLabelHeight:self.actDetailModel.mContent defautWidth:300 defautHeight:10000 fontSize:15];
        }
        else //参加活动的人
        {
            return 110;
        }
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
    // cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.section == 0)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
        ActivityCell *activityCell = (ActivityCell*)cell;
        activityCell.desLabel.hidden = YES;
        [activityCell setDataWithModel:self.actDetailModel];
        [activityCell adjuctSubFrame];

    }
    else
    {
        if (indexPath.row == 0)
        {
            //标题
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5,300 , 30)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont boldSystemFontOfSize:20];
            titleLabel.textColor = RGBACOLOR(0, 140, 207, 1);
            titleLabel.text = indexPath.section == 1?@"活动详情":@"参加活动的人";
            [cell.contentView addSubview:titleLabel];
        }
        else
        {
           if(indexPath.section == 1)//活动详情
           {
               UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5,300 , [StaticTools getLabelHeight:self.actDetailModel.mContent defautWidth:300 defautHeight:10000 fontSize:15])];
               detailLabel.backgroundColor = [UIColor clearColor];
               detailLabel.font = [UIFont systemFontOfSize:15];
               detailLabel.numberOfLines = 0;
               detailLabel.lineBreakMode = UILineBreakModeTailTruncation;
               detailLabel.text =  self.actDetailModel.mContent;
               [cell.contentView addSubview:detailLabel];
           }
           else if(indexPath.section == 2) //参加活动的人
            {
                
                int rowCount = self.pepleListMtbArray.count%4==0?self.pepleListMtbArray.count/4:self.pepleListMtbArray.count/4+1;
                int currentLineCount ;
                if (self.pepleListMtbArray.count%4 == 0)
                {
                    currentLineCount = 4;
                }
                else
                {
                    if (indexPath.row<rowCount)
                    {
                        currentLineCount = 4;
                    }
                    else
                    {
                        currentLineCount = self.pepleListMtbArray.count%4;
                    }
                }

    
                for (int i=0; i<currentLineCount; i++)
                {
                    
                    PersonHeadView *perosnView = [[PersonHeadView alloc]initWithFrame:CGRectMake(5+i*10+70*i, 5, 70, 100)];
                  
                    ProfileModel *model = self.pepleListMtbArray[(indexPath.row-1)*4+i];
                    perosnView.nameLabel.text = model.mName;
                    [perosnView.headImgView setImageWithURL:[NSURL URLWithString:model.mImgUrl] placeholderImage:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
                    [cell.contentView addSubview:perosnView];
                }
            }
        }
    }
   
    
   
 
    return cell;
}

@end
