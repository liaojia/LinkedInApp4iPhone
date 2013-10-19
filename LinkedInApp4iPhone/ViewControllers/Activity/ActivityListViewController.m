//
//  ActivityListViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-19.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//
#import "ActivityCell.h"
#import "ActivityListViewController.h"
#import "ActivityDetailViewController.h"

@interface ActivityListViewController ()

@end

@implementation ActivityListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.listMtbArray  = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"活动列表";
    
    [self getActivityList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setListTableVew:nil];
    [super viewDidUnload];
}

#pragma mark-
#pragma mark--功能函数

/**
 *	@brief	获取活动列表 首页只取前两条显示
 */
- (void)getActivityList
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"page":@"1",@"num":@"2",@"previewLen":@"0",@"typeID":@"0"} requesId:@"COLLEGE_EVENT_LIST" messId:nil success:^(id obj)
         {
             if ([[obj objectForKey:@"rc"]intValue] == 1)
             {
                 NSArray *listArray = obj[@"list"];
                 activityTotalCount = [obj[@"total"] intValue];
                 
                 for (int i=0; i< listArray.count; i++)
                 {
                     NSDictionary *temDict = listArray[i];
                     ProfileModel *model = [[ProfileModel alloc]init];
                     model.mDesc = temDict[@"preview"];
                     model.mName = temDict[@"title"];
                     model.mStime = temDict[@"stime"];
                     model.mPlace = temDict[@"address"];
                     model.mType = temDict[@"typeID"];
                     model.mMoney = temDict[@"charge"];
                     model.mSponsor = temDict[@"sponsor"];
                     model.mImgUrl = temDict[@"pic"];
                     
                     [self.listMtbArray addObject:model];
                     
                 }
                 
                 [self.listTableVew reloadData];
                 
             }
             else if([[obj objectForKey:@"rc"]intValue] == -1)
             {
                 [SVProgressHUD showErrorWithStatus:@"未找到活动信息"];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"活动信息加载失败"];
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
    
    return self.listMtbArray.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProfileModel *model = [self.listMtbArray objectAtIndex:indexPath.row];
    float height = 0;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdenti";
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    ProfileModel *model = self.listMtbArray[indexPath.row];
    ActivityCell *activityCell = (ActivityCell*)cell;
    [activityCell setDataWithModel:model];
    [activityCell adjuctSubFrame];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityDetailViewController *acitvityDetailController = [[ActivityDetailViewController alloc] initWithNibName:@"ActivityDetailViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:acitvityDetailController animated:YES];
}
@end
