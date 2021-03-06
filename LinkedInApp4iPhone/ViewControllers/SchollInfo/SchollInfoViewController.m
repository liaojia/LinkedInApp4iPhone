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
#import <QuartzCore/QuartzCore.h>
#import "FeedOutViewController.h"
#import "ImageShowView.h"

@interface SchollInfoViewController ()
{
    int schollInfoTotalCount;   //母校动态信息条数
    int currentPicIndex;
}
@end

@implementation SchollInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.imgArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"母校信息";
    
    self.schollImgbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.schollImgbtn setBackgroundImage:[UIImage imageNamed:@"image01.jpg"] forState:UIControlStateNormal];
    self.schollImgbtn.frame =CGRectMake(5, 5, 290, 160);
    self.schollImgbtn.tag = 300;
    [self.schollImgbtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.listTableView.backgroundView = nil;
    self.listTableView.backgroundColor = [UIColor clearColor];
    
    [self getSchollInfoListInfo];
    
    [self getImgInfo];
    
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [NSThread detachNewThreadSelector:@selector(initTimer) toTarget:self withObject:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--功能函数
- (void)initTimer
{
    currentPicIndex = 1;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changePic) userInfo:nil repeats:YES];
    
    while (self.timer!=nil) {
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    

}
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
/**
 *  印象首师图片切换
 */
- (void)changePic
{
    if (self.imgArray.count==0)
    {
        return;
    }
    
    currentPicIndex++;
    if(currentPicIndex>self.imgArray.count)
    {
        currentPicIndex=1;
    }
    
    
    CATransition *transition = [CATransition animation];
	transition.duration = 0.5;
	transition.type = kCATransitionReveal;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	transition.subtype =kCATransitionFromRight;
    [self.schollImgbtn setBackgroundImage:self.imgArray[currentPicIndex-1] forState:UIControlStateNormal];
    [self.schollImgbtn.layer addAnimation:transition forKey:nil];
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
                                                     model.mTitle = temDict[@"title"];
                                                     
                                                    
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

/**
 *  获取印象首师第一页的图片列表
 *
 *  @param page
 */
- (void)getImgInfo
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] sendRequestWithRequestDic:@{@"page":[NSString stringWithFormat:@"%d",1],@"num":[NSString stringWithFormat:@"%d",10]} requesId:@"GETPHOTOLIST" messId:nil success:^(id obj)
             {
                 if ([[obj objectForKey:@"rc"]intValue] == 1)
                 {
                     
                     NSArray *listArray = obj[@"list"];
                     
                     self.imgInfoArray = [NSMutableArray arrayWithArray:listArray];
                     for (int i=0;i<self.imgInfoArray.count;i++)
                     {
                         NSDictionary *dict = self.imgInfoArray[i];
//                         [self.imgArray addObject:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
                         AFImageRequestOperation* operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dict[@"thumbnail"]]] success:^(UIImage *image) {
                             
                             [self.imgArray addObject:image];
                             [self changePic];
                         }]; 
                         
                         [operation start];
                         
                     }
                    
                     
                 }
                 else if([[obj objectForKey:@"rc"]intValue] == -1)
                 {
                     [SVProgressHUD showErrorWithStatus:@"印象首师图片数据加载失败！"];
                 }
                 else
                 {
                     [SVProgressHUD showErrorWithStatus:@"印象首师图片数据加载失败！"];
                 }
                 
                 
             } failure:nil];

    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:nil
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
        case 200: //捐款方式
        {
            FeedOutViewController *feedOutController = [[FeedOutViewController alloc]initWithNibName:@"FeedOutViewController" bundle:nil];
            [self.navigationController pushViewController:feedOutController animated:YES];
            
        }
            break;
        case 300: //印象首师 图片查看
        {

            if (self.imgInfoArray.count<currentPicIndex)
            {
                return;
            }
            
            CGRect frame ;
            if (IOS7_OR_LATER)
            {
                frame = self.view.frame;
            }
            else
            {
                frame = CGRectMake(0, 64, 320, self.view.frame.size.height);
            }
            NSDictionary *temDict = self.imgInfoArray[currentPicIndex-1];
            ImageShowView * imageShowView  = [[ImageShowView alloc]initWithFrame:frame url:temDict[@"pic"]];;
            
            [self.view.superview.superview addSubview:imageShowView];
            
            CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            animation.duration = 0.2;
            NSMutableArray *values = [NSMutableArray array];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
            animation.values = values;
            [imageShowView.layer addAnimation:animation forKey:nil];
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
        return (self.schoolInfoMtbArray.count>3?3:self.schoolInfoMtbArray.count)+1;
    }
 
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1||indexPath.section == 2)
    {
        return indexPath.row == 0?44:170;
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
        titleLabel.font  = [UIFont boldSystemFontOfSize:16];
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
        titleLabel.textColor = RGBCOLOR(29, 60, 229);
        [cell.contentView addSubview:titleLabel];
        
        //右侧操作按钮
        
        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        detailBtn.frame = CGRectMake(tableView.frame.size.width-100, 13, 70, 25);
        [detailBtn setBackgroundImage:[UIImage imageNamed:detailImg] forState:UIControlStateNormal];
        [detailBtn setBackgroundImage:[UIImage imageNamed:detailPressImg] forState:UIControlStateHighlighted];
         detailBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        
        detailBtn.tag = 100+indexPath.section;
        [detailBtn addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        [detailBtn setTitle:dtailStr forState:UIControlStateNormal];
        
        if ((indexPath.section==0&&schollInfoTotalCount>3)||
            indexPath.section!=3)
        {
            [cell.contentView addSubview:detailBtn];
        }
        
        return cell;
    }
    
    if (indexPath.section==0)
    {
        static NSString *CellIdentifier = @"CellIdenti";
        ListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==Nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:nil options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ProfileModel *model = self.schoolInfoMtbArray[indexPath.row];
        [cell.headImgView setImageWithURL:[NSURL URLWithString:model.mImgUrl ] placeholderImage:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
        cell.txtLabel.text = model.mTitle;

        return cell;
    }
    else if(indexPath.section == 1) //印象首师
    {
        [cell.contentView addSubview:self.schollImgbtn];
        return cell;
    }
    else if(indexPath.section == 2) //校友捐赠
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(5, 5,290, 160);
        [button setBackgroundImage:[UIImage imageNamed:@"img_feedback.jpg"] forState:UIControlStateNormal];
        [cell.contentView addSubview:button];
        button.tag = 200;
        [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if(indexPath.section == 3)
    {
      
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //学校图片
        UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 70, 90)];
        headImgView.backgroundColor = [UIColor grayColor];
       
        //[headImgView setImageWithURL:[NSURL URLWithString:self.schollInfoModel.mImgUrl] placeholderImage:[UIImage imageNamed:@"img_weibo_item_pic_loading"]];
        headImgView.image = [UIImage imageNamed:@"img_school_logo.jpg"];
//        headImgView.layer.borderColor = [UIColor grayColor].CGColor;
//        headImgView.layer.borderWidth = 2;
        [cell.contentView addSubview:headImgView];
        
        //学校名称
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 200, 30)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.numberOfLines = 0;
        nameLabel.lineBreakMode = UILineBreakModeWordWrap;
        nameLabel.textColor = RGBACOLOR(0, 140, 207, 1);
        nameLabel.font = [UIFont boldSystemFontOfSize:16];
        nameLabel.text = @"首都师范大学";
        [cell.contentView addSubview:nameLabel];
        
        //学校详情
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 35, 180, 70)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:14];
        detailLabel.lineBreakMode = UILineBreakModeTailTruncation;
        detailLabel.numberOfLines = 6;
        detailLabel.text = @"首都师范大学创建于1954年，是一所包括文、理、工、管、法、教育、外语、艺术等专业的综合性师范大学，是北京市重点投入建设，进入“211工程”的北京市属重点大学。";
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
    else if(indexPath.section==3) //数据母校
    {
        FeedOutViewController *feedOutController = [[FeedOutViewController alloc]initWithNibName:@"FeedOutViewController" bundle:nil];
        feedOutController.pageType=1;
        [self.navigationController pushViewController:feedOutController animated:YES];
    }
}

@end
