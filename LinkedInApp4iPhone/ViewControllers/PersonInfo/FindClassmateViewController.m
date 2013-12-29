//
//  FindClassmateViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-21.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "FindClassmateViewController.h"
#import "PersonCell.h"
#import "PersonInfoViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FindClassmateViewController ()

@end

@implementation FindClassmateViewController

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
    
    self.navigationItem.title = @"找同学";
    
    self.resultMtbArray = [NSMutableArray arrayWithCapacity:0];
    
    // Do any additional setup after loading the view from its nib.
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame  = CGRectMake(20, 5, 280, 30);
    [moreBtn setTitleColor:RGBACOLOR(0, 140, 207, 1) forState:UIControlStateNormal];
    moreBtn.layer.borderColor = RGBACOLOR(0, 140, 207, 1).CGColor;
    moreBtn.layer.borderWidth = 1;
    [moreBtn setTitle:@"点击加载更多" forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:moreBtn];
    self.listTableView.tableFooterView = footView;
    self.listTableView.tableFooterView.hidden = YES;
    
    [self.searchBar becomeFirstResponder];
    
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
#pragma mark--UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.resultMtbArray removeAllObjects];
    clickSearch = YES;
    [self getClassmateWithPage:1];
    [searchBar resignFirstResponder];
}

#pragma mark-
#pragma mark--UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}
#pragma mark-
#pragma mark--按钮点击事件
- (void)buttonClickHandle:(id)sender
{
    [self getClassmateWithPage:currentPage+1];
}
#pragma mark-
#pragma mark-发送http请求
- (void)getClassmateWithPage:(int)page
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%d",page],@"page", kPAGESIZE, @"num", self.searchBar.text,@"keywords",nil];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:dic requesId:@"FINDCLASSMATE" messId:nil success:^(id obj)
                     {
                         if ([[obj objectForKey:@"rc"]intValue] == 1)
                         {
                          
                             if (clickSearch)
                             {
                                 currentPage=1;
                             }
                             else
                             {
                                 currentPage++;
                             }
                             
                             int total = [[obj objectForKey:@"total"]intValue];
                             if (total==0)
                             {
                                 [SVProgressHUD showErrorWithStatus:@"未找到匹配结果！"];
                             }
                            
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
                                 [model setMImgUrl:[obj2 objectForKey:@"pic"]];
                                 [self.resultMtbArray addObject:model];
                             }
                             if (self.resultMtbArray.count<total)
                             {
                                 self.listTableView.tableFooterView.hidden = NO;
                             }
                             else
                             {
                                 self.listTableView.tableFooterView.hidden = YES;
                             }
                             
                            
                         }
                         else if([[obj objectForKey:@"rc"]intValue] == -1)
                         {
                             [SVProgressHUD showErrorWithStatus:@"未找到匹配结果！"];
                         }
                         else
                         {
                             [SVProgressHUD showErrorWithStatus:@"加载失败！"];
                         }
                         
                          [self.listTableView reloadData];
                         
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonCell" owner:nil options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    ProfileModel *model = self.resultMtbArray[indexPath.row];
    cell.nameLabel.text = model.mName;
    cell.sexLabel.text = model.mGender;
    [cell.headImg setImageWithURL:[NSURL URLWithString:model.mImgUrl] placeholderImage:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
    cell.placeLabel.text = [NSString stringWithFormat:@"%@--%@", model.mProvince, model.mCity];
    cell.actionBtn.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonInfoViewController *perosnInforController = [[PersonInfoViewController alloc]initWithNibName:@"PersonInfoViewController" bundle:[NSBundle mainBundle]];
     perosnInforController.pageType = 1;
    perosnInforController.personId = ((ProfileModel*)[self.resultMtbArray objectAtIndex:indexPath.row]).mId;
    [self.navigationController pushViewController:perosnInforController animated:YES];
    

}
@end
