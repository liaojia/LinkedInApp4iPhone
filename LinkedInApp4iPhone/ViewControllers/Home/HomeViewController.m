//
//  HomeViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-10-15.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "HomeViewController.h"
#import "NoticeListViewController.h"
#import "ActivityCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ActivityDetailViewController.h"

#define Tag_Back_Action 200
#define Tag_Search_Action 201

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        testArray = @[@"北京师范大学"
                      ,@"北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细北京师范大学详细"
                      ,@"公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容公告内容"
                      ,@"活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述活动描述"
                      ,@"活动题目活动题目活动题目活动题目活动题目活动题目活动题目"
                      ,@"2013-12-12 12:24"
                      ,@"活动地点活动地点活动地点活动地点活动地点活动地点活动地点活动地点活动地点"
                      ,@"活动类型活动类型活动类型活动类型活动类型活动类型活动类型"
                      ,@"活动费用活动费用活动费用活动费用活动费用活动费用活动费用"
                      ,@"主办方主办方主办方主办方主办方主办方主办方主办方主办方主办方"];
        
        personInfoController = [[PersonInfoViewController alloc]initWithNibName:@"PersonInfoViewController" bundle:[NSBundle mainBundle]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.backgroundView = nil;
    
   
}
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    //必须放到viewdidappear里 否则将会被自定义的导航栏重置
    [self initNavLeftButton];
    [self initNavTitleView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationItem.titleView = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--功能函数
/**
 *	@brief	初始化导航栏左侧按钮
 */
- (void)initNavLeftButton
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 35, 35);
    leftBtn.tag  = Tag_Back_Action;
    if (![self.view.subviews containsObject:personInfoController.view])
    {
        [leftBtn setImage:[UIImage imageNamed:@"img_list_normal"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"img_list_pressed"] forState:UIControlStateHighlighted];
    }
    else
    {
        [leftBtn setImage:[UIImage imageNamed:@"img_list_right_normal"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"img_list_right_pressed"] forState:UIControlStateHighlighted];
    }
 
    [leftBtn addTarget:self action:@selector(buttonClickedHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
}

/**
 *	@brief	初始化顶部搜索视图
 */
- (void)initNavTitleView
{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UITextField *searchTxtField = [[UITextField alloc]initWithFrame:CGRectMake(50, 5, 150, 30)];
    searchTxtField.backgroundColor = [UIColor whiteColor];
    [titleView addSubview:searchTxtField];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchBtn.frame = CGRectMake(210, 5, 30,30);
    searchBtn.tag = Tag_Search_Action;
    [searchBtn addTarget:self action:@selector(buttonClickedHandle:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:searchBtn];
    
    self.navigationItem.titleView = titleView;
    
}

/**
 *	@brief	获取字符串的size 换行模式为UILineBreakModeWordWrap
 *
 *	@param 	str
 *
 *	@return	
 */
-(float)getStringHeight:(NSString*)str withFont:(UIFont*)font consSize:(CGSize)size
{
    CGSize strSize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    return strSize.height;
}
#pragma mark-
#pragma mark--按钮点击事件
- (IBAction)buttonClickedHandle:(id)sender
{
    UIButton *button = (UIButton*)sender;
    switch (button.tag) {
        case Tag_Back_Action: //导航栏左侧按钮
        {
            //使用addsubview的方式加入viewcontroller  需主动设置其frame  否则系统会默认使用xib里的大小 
            personInfoController.view.frame = self.view.frame;
            
            [UIView beginAnimations:@"View Flip" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
           
            if (![self.view.subviews containsObject:personInfoController.view])
            {
                [self.view addSubview:personInfoController.view];
                [UIView setAnimationTransition:
                 UIViewAnimationTransitionFlipFromLeft
                                       forView:self.navigationController.view cache:YES];
            }
            else
            {
                [personInfoController.view removeFromSuperview];
                [UIView setAnimationTransition:
                 UIViewAnimationTransitionFlipFromRight
                                       forView:self.navigationController.view cache:YES];
            }
            [UIView commitAnimations];
            [self initNavLeftButton];
            
        }
            break;
        case Tag_Search_Action: //导航栏搜索按钮
        {
            UIAlertView *alet = [[UIAlertView alloc]initWithTitle:nil message:@"搜索点击了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alet show];
            
        }
            break;
        case 101: //官方公告
        {
            
            NoticeListViewController *noticeController = [[NoticeListViewController alloc]initWithNibName:@"NoticeListViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:noticeController animated:YES];
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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if(section == 2)
    {
        return 3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 2&&indexPath.row!=0) //官方活动
    {

        float height = 0;
        for (int i=0; i<7; i++)
        {
            height+=[self getStringHeight:testArray[i+3] withFont:[UIFont systemFontOfSize:17] consSize:CGSizeMake(135, 1000)];
        }
        
        return height;
    }
    else if(indexPath.section ==0) //学校简介
    {
        return 150;
    }
    else if(indexPath.section ==3&&indexPath.row!=0) //校园卡
    {
        return 80;
    }
    else if(indexPath.section == 1&&indexPath.row !=0) //官方公告
    {
        return [self getStringHeight:testArray[2] withFont:[UIFont systemFontOfSize:17] consSize:CGSizeMake(290, 1000)]+35;
    }
    else if(indexPath.section == 4&&indexPath.row !=0) //官方微博
    {
        return 120;
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
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.section == 0) //学校简介
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //学校图片
        UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 20, 100, 100)];
        headImgView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:headImgView];
        
        //学校名称
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 5, 200, [self getStringHeight:testArray[0] withFont:[UIFont boldSystemFontOfSize:20] consSize:CGSizeMake(200, 1000)])];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.numberOfLines = 0;
        nameLabel.lineBreakMode = UILineBreakModeWordWrap;
        nameLabel.textColor = RGBACOLOR(0, 140, 207, 1);
        nameLabel.font = [UIFont boldSystemFontOfSize:20];
        nameLabel.text = testArray[0];
        [cell.contentView addSubview:nameLabel];
        
        //学校详情
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, nameLabel.frame.origin.y+nameLabel.frame.size.height+5, 180, 150-10-nameLabel.frame.size.height)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.lineBreakMode = UILineBreakModeTailTruncation;
        detailLabel.numberOfLines = 6;
        //detailLabel.font = [UIFont boldSystemFontOfSize:20];
        detailLabel.text = testArray[1];
        [cell.contentView addSubview:detailLabel];
    }
    else
    {
        
        if (indexPath.row == 0) //section组别标题
        {
            //左侧标题文字
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
            titleLabel.backgroundColor = [UIColor clearColor];
            NSString *titleStr;
            NSString *dtailStr = @"查看更多";
            NSString *detailImg;
            NSString *detailPressImg;
            if (indexPath.section == 1)
            {
                titleStr = @"官方公告";
                detailImg = @"img_school_notice_normal";
                detailPressImg = @"img_school_notice_pressed";
            }
            else if(indexPath.section == 2)
            {
                titleStr = @"官方活动";
            }
            else if(indexPath.section == 3)
            {
                titleStr = @"校友卡";
                dtailStr = @"我要申请";
                detailImg = @"img_school_card_app_normal";
                detailPressImg = @"img_school_card_app_pressed";
            }
            else if(indexPath.section == 4)
            {
                titleStr = @"官方微博";
                detailImg = @"img_school_notice_normal";
                detailPressImg = @"img_school_notice_pressed";
            }
            
            titleLabel.text = titleStr;
            [cell.contentView addSubview:titleLabel];
            
            //右侧操作按钮
            if(indexPath.section != 2)
            {
                UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                detailBtn.frame = CGRectMake(tableView.frame.size.width-130, 5, 100, 35);
                [detailBtn setBackgroundImage:[UIImage imageNamed:detailImg] forState:UIControlStateNormal];
                [detailBtn setBackgroundImage:[UIImage imageNamed:detailPressImg] forState:UIControlStateHighlighted];
                
                if (indexPath.section == 3) //“我要申请”文字需左移 
                {
                  detailBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
                }
                detailBtn.tag = 100+indexPath.section;
                [detailBtn addTarget:self action:@selector(buttonClickedHandle:) forControlEvents:UIControlEventTouchUpInside];
                [detailBtn setTitle:dtailStr forState:UIControlStateNormal];
                [cell.contentView addSubview:detailBtn];
            }
          
        }
        else  //section组别详细内容
        {
          if(indexPath.section == 1) //官方公告
          {
               
              //公告内容
              UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 290, [self getStringHeight:testArray[2] withFont:[UIFont systemFontOfSize:17] consSize:CGSizeMake(290, 1000)])];
              infoLabel.backgroundColor = [UIColor clearColor];
              infoLabel.numberOfLines = 0;
              infoLabel.lineBreakMode = UILineBreakModeWordWrap;
              infoLabel.font = [UIFont systemFontOfSize:17];
              infoLabel.text = testArray[2];
              [cell.contentView addSubview:infoLabel];
              
              //公告时间
              UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, infoLabel.frame.origin.y+infoLabel.frame.size.height, 190, 30)];
              timeLabel.backgroundColor = [UIColor clearColor];
              timeLabel.textAlignment = UITextAlignmentRight;
              timeLabel.text = @"2013-13-13 12:34";
              [cell.contentView addSubview:timeLabel];
              
              //灰色背景
              UIView *backGroundView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 290,timeLabel.frame.origin.y+20)];
              backGroundView.backgroundColor = [UIColor grayColor];
              backGroundView.layer.cornerRadius = 3;
              [cell.contentView insertSubview:backGroundView belowSubview:infoLabel];
          }
          else if(indexPath.section == 2) //官方活动
          {
             cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCell" owner:nil options:nil] objectAtIndex:0];
              cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
          else if(indexPath.section == 3) //校园卡
          {
              UIButton *leftCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
              leftCardBtn.frame = CGRectMake(5, 5, 140, 70);
              [leftCardBtn setBackgroundImage:[UIImage imageNamed:@"img_school_card_back"] forState:UIControlStateNormal];
              [cell.contentView addSubview:leftCardBtn];
              
              UIButton *rightCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
              rightCardBtn.frame = CGRectMake(155, 5, 140, 70);
              [rightCardBtn setBackgroundImage:[UIImage imageNamed:@"img_school_card_front"] forState:UIControlStateNormal];
              [cell.contentView addSubview:rightCardBtn];
          }
            
        }

    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==2)
    {
        ActivityDetailViewController *activityDetailController = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:activityDetailController animated:YES];
    }
}
@end
