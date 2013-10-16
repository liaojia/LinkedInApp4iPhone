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
@interface ActivityDetailViewController ()

@end

@implementation ActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        testArray = @[@"活动详情活动详情活动详情活动详情活动详情活动详情活动详情活动详情活动详情活动详情活动详情活动详情活动详情活动详情活动详情活动详情活动详情活动详情活动详情活动详情"
                      ,@"北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细"
                      ,@"公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容"
                      ,@"活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述"
                      ,@"活动题目活动题目活动题目活动题目活动题目活动题目活动题目"
                      ,@"2013-12-12 12:24"
                      ,@"活动地点活动地点活动地点活动地点活动地点活动地点活动地点活动地点活动地点"
                      ,@"活动类型活动类型活动类型活动类型活动类型活动类型活动类型"
                      ,@"活动费用活动费用活动费用活动费用活动费用活动费用活动费用"
                      ,@"主办方主办方主办方主办方主办方主办方主办方主办方主办方主办方"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"活动详情";
    self.listTableView.separatorColor = [UIColor clearColor];
    
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
-(float)getStringHeight:(NSString*)str withFont:(UIFont*)font consSize:(CGSize)size
{
    CGSize strSize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    return strSize.height;
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
        return 1;
    }
    else if(section == 1)
    {
        return 2;
    }
    return 3;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        float height = 0;
        for (int i=0; i<7; i++)
        {
            height+=[self getStringHeight:testArray[i+3] withFont:[UIFont systemFontOfSize:17] consSize:CGSizeMake(135, 1000)];
        }
        
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
            return [self getStringHeight: testArray[0] withFont:[UIFont systemFontOfSize:17] consSize:CGSizeMake(300, 1000)];
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
        activityCell.desLabel.text = testArray[3];
        activityCell.titleDetailLabel.text = testArray[4];
        activityCell.timeDetailLabel.text = testArray[5];
        activityCell.placeDetailLabel.text = testArray[6];
        activityCell.typeDetailLabel.text = testArray[7];
        activityCell.moneyDetailLabel.text = testArray[8];
        activityCell.hostDetailLabel.text = testArray[9];
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
               UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5,300 , [self getStringHeight: testArray[0] withFont:[UIFont systemFontOfSize:17] consSize:CGSizeMake(300, 1000)])];
               detailLabel.backgroundColor = [UIColor clearColor];
               detailLabel.font = [UIFont systemFontOfSize:17];
               detailLabel.numberOfLines = 0;
               detailLabel.lineBreakMode = UILineBreakModeTailTruncation;
               detailLabel.text =  testArray[0];
               [cell.contentView addSubview:detailLabel];
           }
           else if(indexPath.section == 2) //参加活动的人
            {
                for (int i=0; i<4; i++)
                {
                    PersonHeadView *perosnView = [[PersonHeadView alloc]initWithFrame:CGRectMake(5+i*10+70*i, 5, 70, 100)];
                    perosnView.nameLabel.text = @"文彬";
                    [cell.contentView addSubview:perosnView];
                }
            }
        }
    }
   
    
   
 
    return cell;
}

@end
