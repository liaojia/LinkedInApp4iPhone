//
//  MyCircleViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-28.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "MyCircleViewController.h"
#import "CircleInfoViewController.h"
#import "CreateCircleViewController.h"

@interface MyCircleViewController ()

@end

@implementation MyCircleViewController

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
    
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.backgroundView = nil;
    [self initTableview];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(280, 5, 70, 30);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightBtn.tag = 201;
    [rightBtn setTitle:@"创建圈子" forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_find_stu_n"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_find_stu_s"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.resultMtbArray = [NSMutableArray arrayWithCapacity:0];
    
    [self getListInfoWithPage:1];
    
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
    moreBtn.tag = 200;
    [moreBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:moreBtn];
    self.listTableView.tableFooterView = footView;
    self.listTableView.tableFooterView.hidden = YES;
    
    
}

#pragma mark-
#pragma mark--发送http请求
/**
 *  获取校友动态信息
 */
- (void)getListInfoWithPage:(int)page
{
    NSString *resuestId = nil;
    if (operateType==1)
    {
        resuestId = @"MYJOINCIRCLE";
    }
    else if (operateType==0)
    {
        resuestId = @"MYCREATECIRCLE";
    }
    else if (operateType==2)
    {
        resuestId = @"COMMENDCIRCLE";
    }
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"page":[NSString stringWithFormat:@"%d",page],@"num":kPAGESIZE} requesId:resuestId messId:nil success:^(id obj)
                                         {
                                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                                             {
                                                 currentPage++;
                                                 NSArray *listArray = obj[@"list"];
                                                 listTotalCount = [obj[@"total"] intValue];
                                                 
                                                 [self.resultMtbArray addObjectsFromArray:listArray];
                                                 
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
                                                 [SVProgressHUD showErrorWithStatus:@"信息列表加载失败！"];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD showErrorWithStatus:@"信息列表加载失败！"];
                                             }
                                             
                                             
                                         } failure:nil];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
                                   completeBlock:nil];
}

#pragma mark-
#pragma mark--按钮点击事件
- (IBAction)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag)
    {
        case 110:
        case 111:
        case 112:
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                self.lineView.frame = CGRectMake(107*(button.tag-110), self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
            }];
            
            operateType =button.tag-110;
            currentPage=0;
            [self.resultMtbArray removeAllObjects];
            [self.listTableView reloadData];
            [self getListInfoWithPage:1];
        }
            break;
        case 200://查看成员列表
        {
            [self getListInfoWithPage:currentPage+1];
        }
            break;
        case 201: //创建圈子
        {
            CreateCircleViewController *createCirecleCotroller = [[CreateCircleViewController alloc]initWithNibName:@"CreateCircleViewController" bundle:Nil];
            createCirecleCotroller.fatherController = self;
            [self.navigationController pushViewController:createCirecleCotroller animated:YES];
        }
            break;
    
        default:
            break;
    }
    
}
/**
 *  刷新我创建的圈子  创建圈子成功后调用
 */
- (void)refreshMyCreateCricle
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.lineView.frame = CGRectMake(0, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
    }];
    
    operateType =0;
    currentPage=0;
    [self.resultMtbArray removeAllObjects];
    [self.listTableView reloadData];
    [self getListInfoWithPage:1];

}
#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.resultMtbArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.resultMtbArray[indexPath.section];

    
    if (indexPath.row==2)
    {
        return 35;
    }
    else if(indexPath.row==0)
    {
        float height =  [StaticTools getLabelHeight:dict[@"name"] defautWidth:220 defautHeight:480 fontSize:15];
        return height<35?35:height+10;
    }
    else if(indexPath.row == 1)
    {
        float height =  [StaticTools getLabelHeight:dict[@"desc"] defautWidth:220 defautHeight:480 fontSize:15];
        return height<35?35:height+10;

    }
    
    return 35;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 80, 25)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 220, 25)];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.numberOfLines = 0;
    detailLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    detailLabel.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:detailLabel];
    
    NSDictionary *dict = self.resultMtbArray[indexPath.section];
    if (indexPath.row==0)
    {
        titleLabel.text = @"圈子名称";
        detailLabel.text = dict[@"name"];
        //detailLabel.frame = CGRectMake(90, 5, 220, [StaticTools getLabelHeight:dict[@"name"] defautWidth:220 defautHeight:480 fontSize:15]);
    }
    else if(indexPath.row == 1)
    {
        titleLabel.text = @"圈子简介";
        detailLabel.text = dict[@"desc"];
        detailLabel.frame = CGRectMake(90, 5, 220, [StaticTools getLabelHeight:dict[@"desc"] defautWidth:220 defautHeight:480 fontSize:15]);
    }
    else if(indexPath.row == 2)
    {
        titleLabel.text = @"创建时间";
        detailLabel.text = dict[@"createTime"];
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.resultMtbArray[indexPath.section];
    
    CircleInfoViewController *circleInfoController = [[CircleInfoViewController alloc]initWithNibName:@"CircleInfoViewController" bundle:nil];
    circleInfoController.fatherController = self;
    circleInfoController.circleType = operateType;
    circleInfoController.infoDict = [NSDictionary dictionaryWithDictionary:dict];
    [self.navigationController pushViewController:circleInfoController animated:YES];
}
@end
