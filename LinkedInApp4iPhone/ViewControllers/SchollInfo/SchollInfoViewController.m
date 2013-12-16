//
//  SchollInfoViewController.m
//  LinkedInApp4iPhone
//
//  Created by wenbin on 13-12-16.
//  Copyright (c) 2013年 liao jia. All rights reserved.
//

#import "SchollInfoViewController.h"
#import "ListCell.h"
@interface SchollInfoViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        return 4;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
        [detailBtn addTarget:self action:@selector(buttonClickedHandle:) forControlEvents:UIControlEventTouchUpInside];
        [detailBtn setTitle:dtailStr forState:UIControlStateNormal];
        
        if (indexPath.section!=3)
        {
            [cell.contentView addSubview:detailBtn];
        }
        
        
        return cell;
    }
    
    if (indexPath.section==0)
    {
        ListCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:nil options:nil] objectAtIndex:0];
        
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

@end
