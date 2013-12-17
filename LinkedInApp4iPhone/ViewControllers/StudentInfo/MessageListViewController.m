//
//  MessageListViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-17.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "MessageListViewController.h"
#import "ListCell.h"
#import "DetailInfoViewController.h"

@interface MessageListViewController ()
{
    int listTotalCount;  //列表数据总条数
    int currentPage;     //当前页码
}
@end

@implementation MessageListViewController

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
    self.navigationItem.title = @"信息列表";
    self.listTableView.tableHeaderView = self.headView;
    [StaticTools setExtraCellLineHidden:self.listTableView];
    
    self.listInfoMtbArray = [NSMutableArray arrayWithCapacity:0];
    
    [self getTopMediaListInfoe];
    
    [self getListInfoWithPage:1];

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
    moreBtn.tag = 200;
    [moreBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:moreBtn];
    self.listTableView.tableFooterView = footView;
    self.listTableView.tableFooterView.hidden = YES;
    
    
}

/**
 *  刷新顶部置顶信息列表
 */
- (void)freshHeader
{
    self.headSclView.contentSize = CGSizeMake(320*self.topInfoMtbArray.count, 160);
    self.headSclView.delegate = self;
    self.headSclView.pagingEnabled = YES;
    self.headPageControl.numberOfPages = self.topInfoMtbArray.count;
    self.headPageControl.currentPage = 0;
    self.headPageControl.hidesForSinglePage = YES;
    self.headTitleLabel.text =self.topInfoMtbArray[0][@"title"];
    for (int i=0;i<self.topInfoMtbArray.count;i++)
    {
        NSDictionary *dict = self.topInfoMtbArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*320, 0, 320, 160);
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self.headSclView addSubview:button];
        
        AFImageRequestOperation* operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dict[@"pic"]]] success:^(UIImage *image) {
            
            NSLog(@"下载图片完成 %@",dict[@"pic"]);
            [button setImage:image forState:UIControlStateNormal];
        }];
        
        [operation start];
    }
}

/**
 *  跳转到详情页面
 *
 *  @param idStr 新闻id
 */
- (void)gotoDetailPageWithID:(NSString*)idStr
{
    DetailInfoViewController *detailController = [[DetailInfoViewController alloc]initWithNibName:@"DetailInfoViewController" bundle:Nil];
    detailController.listId = idStr;
    detailController.typeId = [NSString stringWithFormat:@"%d",self.type];
    [self.navigationController pushViewController:detailController animated:YES];

}
#pragma mark-
#pragma mark--按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button.tag==200) //点击加载更多
    {
        [self getListInfoWithPage:currentPage+1];
    }
    else //点击置顶信息
    {
        NSDictionary *dict = self.topInfoMtbArray[button.tag-100];
        [self gotoDetailPageWithID:[NSString stringWithFormat:@"%@",dict[@"id"]]];

    }
    
}
#pragma mark-
#pragma mark--发送http请求
/**
 *  获取置顶媒体信息列表
 */
- (void)getTopMediaListInfoe
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"type":[NSString stringWithFormat:@"%d",self.type]} requesId:@"GETTOPMEDIAINFO" messId:nil success:^(id obj)
                         {
                             if ([[obj objectForKey:@"rc"]intValue] == 1)
                             {
                                 
                                 NSArray *listArray = obj[@"list"];
                                 self.topInfoMtbArray = [NSMutableArray arrayWithArray:listArray];
                                
                                 if (self.topInfoMtbArray.count>0)
                                 {
                                     [self freshHeader];
                                 }
                                
                             }
                             
                             else if([[obj objectForKey:@"rc"]intValue] == -1)
                             {
                                 [SVProgressHUD showErrorWithStatus:@"置顶信息下载失败"];
                             }
                             else
                             {
                                 [SVProgressHUD showErrorWithStatus:@"置顶信息下载失败"];
                             }
                             
                             
                         } failure:nil];

    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
                                   completeBlock:nil];
}

/**
 *  获取校友动态信息
 */
- (void)getListInfoWithPage:(int)page
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"page":[NSString stringWithFormat:@"%d",page],@"num":kPAGESIZE,@"previewLen":@"50",@"type":[NSString stringWithFormat:@"%d",self.type]} requesId:@"CUSTOMEMEDIOLISTINFO" messId:nil success:^(id obj)
                             {
                                 if ([[obj objectForKey:@"rc"]intValue] == 1)
                                 {
                                     currentPage++;
                                     NSArray *listArray = obj[@"list"];
                                     listTotalCount = [obj[@"total"] intValue];
                                     
                                     
                                     for (int i=0; i< listArray.count; i++)
                                     {
                                         NSDictionary *temDict = listArray[i];
                                         ProfileModel *model = [[ProfileModel alloc]init];
                                         model.mDesc = temDict[@"preview"];
                                         model.mImgUrl = temDict[@"pic"];
                                         model.mId = temDict[@"id"];
                                        
                                         [self.listInfoMtbArray addObject:model];
                                     }
                                     
                                     if (self.listInfoMtbArray.count>=listTotalCount)
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
#pragma mark--UIScorllViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.headPageControl.currentPage = self.headSclView.contentOffset.x/320;
     self.headTitleLabel.text =self.topInfoMtbArray[self.headPageControl.currentPage][@"title"];
}
#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listInfoMtbArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"ListCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ProfileModel *model = self.listInfoMtbArray[indexPath.row];
    [cell.headImgView setImageWithURL:[NSURL URLWithString:model.mImgUrl ] placeholderImage:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
    cell.txtLabel.text = model.mDesc;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProfileModel *model = self.listInfoMtbArray[indexPath.row];
    [self gotoDetailPageWithID:model.mId];
}

@end
